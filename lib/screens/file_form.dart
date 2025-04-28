// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:archive/config/globals.dart';
import 'package:archive/config/theme.dart';
import 'package:archive/models/my_file.dart';
import 'package:archive/my_widgets/alerts.dart';
import 'package:archive/my_widgets/button.dart';
import 'package:archive/my_widgets/input.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

class FileForm extends StatefulWidget {
  final bool withFolder;

  /// If `reference` is non-null, we upload into that subcollection instead of the root.
  final CollectionReference? reference;

  const FileForm({
    super.key,
    this.withFolder = false,
    this.reference,
  });

  @override
  State<FileForm> createState() => _FileFormState();
}

class _FileFormState extends State<FileForm> {
  final GlobalKey<FormState> _fileKey = GlobalKey<FormState>();
  final _folderCtrl = TextEditingController();

  Set<File> files = {};
  Set<File> uploadedFiles = {};
  double progress = 0.0;

  /// Show a non-dismissible progress dialog.
  void _showProgressDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        icon: const Icon(Icons.cloud_upload_rounded,
            size: 50, color: Colors.blue),
        title: const Text("Uploading…"),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: LinearProgressIndicator(
            value: files.isEmpty ? null : progress,
            minHeight: 8,
            borderRadius: BorderRadius.circular(8),
            backgroundColor: Colors.grey.shade200,
          ),
        ),
      ),
    );
  }

  /// Let user pick one or more files.
  Future<void> selectFiles() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      setState(() {
        files = result.paths.map((p) => File(p!)).toSet();
      });
    }
  }

  /// Upload a single file, updating `progress`.
  Future<String?> upload(File file) async {
    try {
      final ref = storage.ref().child('files/${p.basename(file.path)}');
      final task = ref.putFile(file);

      task.snapshotEvents.listen((snap) {
        setState(() {
          progress = snap.totalBytes > 0
              ? snap.bytesTransferred / snap.totalBytes
              : 0.0;
          if (snap.state == TaskState.success) {
            uploadedFiles.add(file);
          }
        });
      });

      final snapshot = await task.whenComplete(() {});
      return await snapshot.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      alertFunction(context, "Upload failed: ${e.message}", () {
        Navigator.of(context).pop(); // dismiss
      });
      return null;
    }
  }

  /// Main save() entrypoint: handles both folder and file branches.
  Future<void> save() async {
    final fileRef = widget.reference ?? MyFile.getRef();

    // ── Folder creation branch ─────────────────────────────────────────────
    if (widget.withFolder) {
      if (!_fileKey.currentState!.validate()) return;
      showPreloader(context, "Creating Folder...");
      final baseDoc = fileRef.doc(MyFile.baseSubFolderName);
      final existing = await baseDoc.get().then((snap) {
        return List<String>.from(snap.get(MyFile.baseSubFolderName));
      });

      final name = _folderCtrl.text.trim();
      if (existing.contains(name)) {
        Navigator.of(context).pop(); // hide preloader
        alert(context, "Folder already exists");
        return;
      }
      existing.add(name);

      // create the sub-collection
      await baseDoc
          .collection(name)
          .doc(MyFile.baseSubFolderName)
          .set({MyFile.baseSubFolderName: []});

      // update the folder list
      await baseDoc.set({MyFile.baseSubFolderName: existing});

      Navigator.of(context).pop(); // hide preloader
      Navigator.of(context).pop(); // close sheet
      return;
    }

    // ── File upload branch ─────────────────────────────────────────────────
    if (files.isEmpty) {
      debugPrint("[FileForm] no files to upload");
      return;
    }

    _showProgressDialog(); // show the blocking dialog

    try {
      // Upload each file one by one (or parallel, up to you)
      for (final file in files) {
        final url = await upload(file);
        if (url == null) throw Exception("Upload failed for ${file.path}");

        final myFile = MyFile(
          name: p.basename(file.path),
          path: url,
          timestamp: DateTime.now(),
        );

        // .add() creates a new doc with a unique ID
        await fileRef.add(myFile.toMap());
      }
    } catch (e) {
      // If anything goes wrong, pop the progress dialog and show an error
      Navigator.of(context).pop(); // dismiss progress
      alertFunction(context, "Upload failed: $e", () {
        Navigator.of(context).pop(); // dismiss form
      });
      return;
    }

    // all done!
    if (mounted) {
      Navigator.of(context).pop(); // dismiss progress
      Navigator.of(context).pop(); // dismiss form sheet
    }
  }

  @override
  void dispose() {
    _folderCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _fileKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            widget.withFolder
                ? Icons.create_new_folder_rounded
                : Icons.file_upload_outlined,
            size: 60,
            color: AppTheme.bubble,
          ),
          const SizedBox(height: 8),
          Text(
            widget.withFolder ? "Create Folder" : "Upload File",
            style: AppTheme.medium.copyWith(
              color: AppTheme.primary,
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(height: 20),
          if (widget.withFolder) ...[
            MyInput(
              label: "Folder name",
              hint: "e.g. summer_trip",
              prefix: Icons.folder_open,
              controller: _folderCtrl,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? "Required" : null,
            ),
          ] else ...[
            ElevatedButton.icon(
              onPressed: selectFiles,
              icon: const Icon(Icons.add_rounded),
              label: const Text("Select files"),
            ),
            const SizedBox(height: 8),
            if (files.isNotEmpty)
              ...files.map((f) {
                final name = p.basename(f.path);
                return ListTile(
                  leading: const Icon(Icons.insert_drive_file),
                  title: Text(name),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {
                      setState(() => files.remove(f));
                    },
                  ),
                );
              }),
          ],
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (files.isNotEmpty || widget.withFolder)
                MyButton(
                  onPressedAction: save,
                  label: widget.withFolder ? "Create Folder" : "Start Upload",
                  leadingIcon: Icons.cloud_upload_rounded,
                  width: screenSize.width * 0.5,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

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
  double progress = 1;
  Set<File> files = {};
  Set<File> uploadedFiles = {};

  final GlobalKey<FormState> _fileKey = GlobalKey<FormState>();

  final TextEditingController _name = TextEditingController();
  final TextEditingController _file = TextEditingController();
  final TextEditingController _folder = TextEditingController();

  showProgress(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (_) => PopScope(
        canPop: false,
        child: AlertDialog(
          icon: Icon(
            Icons.cloud_upload_rounded,
            size: 50,
            color: Colors.green[700],
          ),
          title: Text("Uploading, hang tight ..."),
          content: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              borderRadius: BorderRadius.circular(AppTheme.sxLarge),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
          ],
        ),
      ),
    );
  }

  Future save() async {
    CollectionReference fileRef = widget.reference ?? MyFile.getRef();
    DateTime timestamp = DateTime.now();

    if (widget.withFolder) {
      if (_fileKey.currentState!.validate()) {
        showPreloader(context, "Creating Folder...");
        List existingFolders =
            await fileRef.doc(MyFile.baseSubFolderName).get().then((value) {
          return value.get(MyFile.baseSubFolderName);
        });

        print("------$existingFolders");

        if (existingFolders.contains(_folder.text)) {
          if (mounted) {
            Navigator.pop(context); //removes preloader
            alert(context, "Folder already exists");
          }
          return;
        }

        existingFolders.add(_folder.text);

        //creates new folder and adds a folders document with an empty folders lists
        await fileRef
            .doc(MyFile.baseSubFolderName)
            .collection(_folder.text)
            .doc(MyFile.baseSubFolderName)
            .set({MyFile.baseSubFolderName: []});

        //updates folders list (string) in current document or folder
        await fileRef
            .doc(MyFile.baseSubFolderName)
            .set({MyFile.baseSubFolderName: existingFolders});

        if (mounted) {
          Navigator.pop(context);
          Navigator.pop(context);
        }
        return;
      } else {
        return;
      }
    }

    String path = "";
    showProgress(context, "Uploading files");

    for (File file in files) {
      path = await upload(file) ?? "";

      if (path.isEmpty) {
        return;
      }

      MyFile myFile = MyFile(
        name: p.basename(file.path),
        path: path,
        timestamp: timestamp,
      );

      await fileRef.doc(timestamp.toString()).set(myFile.toMap());
    }

    if (mounted) {
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  // Future save() async {
  //   if (_fileKey.currentState!.validate()) {
  //     MyFile file = MyFile(
  //       name: _name.text,
  //       path: _file.text,
  //       timestamp: DateTime.now(),
  //     );
  //
  //     // showPreloader(context, 'Working on it...');
  //     showProgress(context, "");
  //     await file.getRef().add(file.toMap()).then((_) {
  //       if (mounted) {
  //         Navigator.pop(context);
  //         alertSuccessPreloaderFunction(
  //           context,
  //           "Saved and secured!",
  //           () => Navigator.pop(context),
  //         );
  //       }
  //     });
  //   }
  // }

  void selectFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        files = result.paths.map((path) => File(path!)).toSet();
      });
    }
  }

  Future<String?> upload(File file) async {
    try {
      var fileRef = storage.ref().child('files/${p.basename(file.path)}');
      fileRef.putFile(file).snapshotEvents.listen((taskSnapshot) {
        switch (taskSnapshot.state) {
          case TaskState.running:
            setState(() {
              progress =
                  (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
            });
            break;
          case TaskState.paused:
            // ...
            break;
          case TaskState.success:
            setState(() {
              uploadedFiles.add(file);
            });
            break;
          case TaskState.canceled:
            // ...
            break;
          case TaskState.error:
            // ...
            break;
        }
      });
      return await fileRef.getDownloadURL();
    } on FirebaseException catch (e) {
      alert(context, e.toString());
    }
    return null;
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
          Text(
            widget.withFolder ? "Create Folder" : "Upload File",
            style: AppTheme.medium.copyWith(
              color: AppTheme.primary,
              fontWeight: FontWeight.normal,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          if (widget.withFolder)
            MyInput(
              label: "Folder",
              hint: "eg. picnic",
              prefix: Icons.folder_open_rounded,
              // autoFocus: true,
              controller: _folder,
              validator: validator,
            ),
          if (!widget.withFolder)
            ElevatedButton.icon(
              onPressed: selectFiles,
              icon: Icon(Icons.add_rounded),
              label: Text("Add File"),
            ),
          if (!widget.withFolder)
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: screenSize.height * .3),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Card(
                    child: Column(
                      children: files
                          .map((file) => Column(
                                children: [
                                  ListTile(
                                    leading: Icon(Icons.image_outlined),
                                    title: Text(
                                      p.basename(file.path),
                                    ),
                                    trailing: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          files.remove(file);
                                        });
                                      },
                                      visualDensity: VisualDensity.compact,
                                      icon: Icon(
                                        Icons.delete_outline_rounded,
                                        color: AppTheme.error,
                                      ),
                                    ),
                                  ),
                                  Divider(),
                                ],
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ),
            ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(
          //     horizontal: 16.0,
          //     vertical: 8.0,
          //   ),
          //   child: LinearProgressIndicator(
          //     value: 23 / 100,
          //     minHeight: 10,
          //     borderRadius: BorderRadius.circular(AppTheme.sxLarge),
          //   ),
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // ElevatedButton.icon(
              //   onPressed: save,
              //   icon: Icon(
              //     Icons.cloud_upload_rounded,
              //   ),
              //   label: Text("Archive"),
              // ),
              if (files.isNotEmpty || widget.withFolder)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: MyButton(
                    onPressedAction: save,
                    label: widget.withFolder ? "Create Folder" : "Archive",
                    width: screenSize.width * .5,
                    leadingIcon: Icons.cloud_upload_rounded,
                    color: Colors.blue[900],
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }
}

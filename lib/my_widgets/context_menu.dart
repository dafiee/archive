import 'package:archive/config/globals.dart';
import 'package:archive/config/theme.dart';
import 'package:archive/models/my_file.dart';
import 'package:archive/my_widgets/alerts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyContextMenuSheet extends StatefulWidget {
  final dynamic item;
  const MyContextMenuSheet({super.key, required this.item});

  @override
  State<MyContextMenuSheet> createState() => _MyContextMenuSheetState();
}

class _MyContextMenuSheetState extends State<MyContextMenuSheet> {
  void deleteFile(dynamic item) async {
    if (item is MyFile) {
      await item.reference?.delete();
    } else if (item is CollectionReference) {
      DocumentSnapshot? ref = await item.parent?.get();

      List foldersList = ref?.get(MyFile.baseSubFolderName) ?? [];

      if (foldersList.isEmpty || ref == null) {
        return;
      }

      foldersList.remove(item.id);

      await ref.reference.set({MyFile.baseSubFolderName: foldersList});

      final batch = firestore.batch();
      var snapshots = await item.get();

      for (var doc in snapshots.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    }
  }

  void deleteConfirmation(dynamic item) {
    alertFunction(
      context,
      "Confirm Action",
      () async {
        Navigator.pop(context);
        deleteFile(item);
      },
      actionText: "Delete",
      isWarning: true,
      message: item is CollectionReference
          ? "All files and sub folders will be deleted. This action is irreversible! Do you want to continue?"
          : "This action is irreversible!",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            onTap: () {
              Navigator.pop(context);
            },
            title: Text("Download"),
            trailing: Icon(Icons.arrow_right_rounded),
            leading: Icon(Icons.file_download_rounded),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
            },
            title: Text("Share"),
            trailing: Icon(Icons.arrow_right_rounded),
            leading: Icon(Icons.share_rounded),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
            },
            title: Text("Rename"),
            trailing: Icon(Icons.arrow_right_rounded),
            leading: Icon(Icons.edit_rounded),
          ),
          ListTile(
            onTap: () {
              deleteConfirmation(widget.item);
            },
            title: Text(
              "Delete",
              style: TextStyle(color: AppTheme.error),
            ),
            trailing: Icon(
              Icons.arrow_right_rounded,
              color: AppTheme.error,
            ),
            leading: Icon(
              Icons.delete_sweep_rounded,
              color: AppTheme.error,
            ),
          ),
        ],
      ),
    );
  }
}

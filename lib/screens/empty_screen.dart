import 'package:archive/config/globals.dart';
import 'package:archive/config/theme.dart';
import 'package:archive/screens/file_form.dart';
import 'package:flutter/material.dart';

class EmptyScreen extends StatefulWidget {
  const EmptyScreen({super.key});

  @override
  State<EmptyScreen> createState() => _EmptyScreenState();
}

class _EmptyScreenState extends State<EmptyScreen> {
  void createFile({bool withFolder = false}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: FileForm(
          withFolder: withFolder,
        ),
      ),
    );
  }

  void selectFile() {}

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: screenSize.width * .8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_upload_outlined,
              size: 180,
              color: AppTheme.bubble,
            ),
            TextButton.icon(
              onPressed: createFile,
              icon: Icon(Icons.add),
              label: Text("Upload your first file"),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:archive/config/globals.dart';
import 'package:archive/config/theme.dart';
import 'package:archive/models/my_file.dart';
import 'package:archive/my_widgets/context_menu.dart';
import 'package:archive/screens/error_screen.dart';
import 'package:archive/screens/loading_screen.dart';
import 'package:flutter/material.dart';

class FileView extends StatefulWidget {
  final MyFile file;

  const FileView({super.key, required this.file});

  @override
  State<FileView> createState() => _FileViewState();
}

class _FileViewState extends State<FileView> {
  bool imageTapped = false;

  void showContextAction(dynamic item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      constraints: BoxConstraints(maxHeight: screenSize.height * .5),
      builder: (_) => MyContextMenuSheet(
        item: item,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.file.path);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  imageTapped = !imageTapped;
                });
              },
              onLongPress: () {
                showContextAction(widget.file);
              },
              child: Container(
                color: Colors.red.withAlpha(0),
                child: Column(
                  children: [
                    Expanded(
                      child: InteractiveViewer(
                        child: Image.network(
                          widget.file.path,
                          // fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return LoadingScreen(
                              loadingMessage:
                                  "Retrieving your file from cloud...",
                            );
                          },
                          errorBuilder: (context, object, trace) => ErrorScreen(
                            errorMessage: "Media could not be loaded",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (!imageTapped)
              ListTile(
                leading: BackButton(),
                title: Text(widget.file.name),
                contentPadding: EdgeInsets.symmetric(
                  vertical: AppTheme.sMedium,
                ),
                trailing: IconButton(
                  onPressed: () => showContextAction(widget.file),
                  icon: Icon(Icons.more_vert_rounded),
                ),
              )
          ],
        ),
      ),
    );
  }
}

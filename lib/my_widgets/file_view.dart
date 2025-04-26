import 'dart:io';

import 'package:archive/config/globals.dart';
import 'package:archive/config/theme.dart';
import 'package:archive/models/my_file.dart';
import 'package:archive/my_widgets/alerts.dart';
import 'package:archive/my_widgets/context_menu.dart';
import 'package:archive/screens/error_screen.dart';
import 'package:archive/screens/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher.dart';

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

  void openExternally() async {
    const imageExt = ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'];
    const videoExt = ['.mp4', '.mov', '.wmv', '.avi', '.flv', '.mkv', '.webm'];

    // print(p.extension(file.path));

    try {
      if (!imageExt.contains(p.extension(widget.file.path))) {
        if (!await launchUrl(Uri.parse(widget.file.path))) {
          if (mounted) {
            alertFunction(context, "Could not launch file", () {
              Navigator.pop(context);
              Navigator.pop(context);
            });
          }
          // print('Could not launch ${widget.file.path}');
        } else {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      alertFunction(context, "Could not launch file ${e.toString()}", () {
        Navigator.pop(context);
        Navigator.pop(context);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    openExternally();
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

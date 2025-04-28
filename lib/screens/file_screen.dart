// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:archive/config/globals.dart';
import 'package:archive/config/theme.dart';
import 'package:archive/models/my_file.dart';
import 'package:archive/my_widgets/alerts.dart';
import 'package:archive/my_widgets/context_menu.dart';
import 'package:archive/my_widgets/file_view.dart';
import 'package:archive/my_widgets/input.dart';
import 'package:archive/screens/empty_screen.dart';
import 'package:archive/screens/error_screen.dart';
import 'package:archive/screens/file_form.dart';
import 'package:archive/screens/loading_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

class FileScreen extends StatefulWidget {
  final CollectionReference<Map<String, dynamic>> folder;

  const FileScreen({
    super.key,
    required this.folder,
  });

  @override
  State<FileScreen> createState() => _FileScreenState();
}

/// Returns the Material icon that best represents [fileName].
IconData fileIcon(String fileName) {
  final ext = p.extension(fileName).toLowerCase();

  // images
  if (['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'].contains(ext)) {
    return Icons.image_outlined;
  }
  // PDF
  if (ext == '.pdf') return Icons.picture_as_pdf;
  // Word
  if (['.doc', '.docx'].contains(ext)) return Icons.article;
  // Excel
  if (['.xls', '.xlsx'].contains(ext)) return Icons.grid_on;
  // Text
  if (ext == '.txt') return Icons.text_snippet;
  // Video
  if (['.mp4', '.mov', '.wmv', '.avi', '.mkv', '.flv', '.webm'].contains(ext)) {
    return Icons.videocam;
  }
  // **Audio**
  if (['.mp3', '.wav', '.m4a', '.aac', '.ogg', '.flac', '.wma'].contains(ext)) {
    return Icons.audiotrack;
  }
  // fallback
  return Icons.insert_drive_file;
}

/// Returns a color for that file-type icon.
Color fileIconColor(String fileName) {
  final ext = p.extension(fileName).toLowerCase();

  // images
  if (['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'].contains(ext)) {
    return Colors.blueGrey;
  }
  // PDF
  if (ext == '.pdf') return Colors.redAccent;
  // Word
  if (['.doc', '.docx'].contains(ext)) return Colors.blue;
  // Excel
  if (['.xls', '.xlsx'].contains(ext)) return Colors.green;
  // Text
  if (ext == '.txt') return Colors.grey;
  // Video
  if (['.mp4', '.mov', '.wmv', '.avi', '.mkv', '.flv', '.webm'].contains(ext)) {
    return Colors.deepPurple;
  }
  // **Audio**
  if (['.mp3', '.wav', '.m4a', '.aac', '.ogg', '.flac', '.wma'].contains(ext)) {
    return Colors.orange;
  }
  // fallback
  return Colors.grey;
}

class _FileScreenState extends State<FileScreen> {
  List<QueryDocumentSnapshot> folderList = [];
  List<CollectionReference> docFolders = [];
  List<MyFile> files = [];

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

  void createFile({bool withFolder = false, CollectionReference? reference}) {
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
          reference: reference,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.folder.id),
        actions: [
          IconButton(
            onPressed: () => createFile(
              withFolder: true,
              reference: widget.folder,
            ),
            icon: Icon(Icons.create_new_folder_outlined),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                viewAsList = !viewAsList;
              });
            },
            icon: Icon(
              viewAsList ? Icons.grid_view_rounded : Icons.view_list_rounded,
            ),
          ),
          PopupMenuButton(
            shape: RoundedRectangleBorder(),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: ListTile(
                  visualDensity: VisualDensity.compact,
                  leading: Icon(
                    Icons.power_settings_new_rounded,
                    color: AppTheme.error,
                  ),
                  title: Text(
                    "Log out",
                    style: TextStyle(color: AppTheme.error),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          MyInput(
            prefix: Icons.search_rounded,
            hint: "Type your search keyword",
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: widget.folder.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return ErrorScreen(
                    errorMessage: snapshot.error.toString(),
                  );
                }

                if (snapshot.hasData) {
                  List<QueryDocumentSnapshot> docs = snapshot.data!.docs;

                  folderList = docs
                      .where((doc) => doc.id == MyFile.baseSubFolderName)
                      .toList();

                  QueryDocumentSnapshot? folderDoc =
                      folderList.isNotEmpty ? folderList.first : null;

                  if (folderDoc != null) {
                    List docFolderString =
                        folderDoc.get(MyFile.baseSubFolderName);
                    docFolders = List.generate(
                      docFolderString.length,
                      (index) => folderDoc.reference
                          .collection(docFolderString[index].toString()),
                    );
                  }

                  docs.removeWhere(
                    (item) => item.id == MyFile.baseSubFolderName,
                  );

                  files = List.generate(docs.length, (index) {
                    return MyFile.fromMap(
                      docs[index].data() as Map<String, dynamic>,
                      docs[index].reference,
                    );
                  });

                  if (files.isEmpty && docFolders.isEmpty) {
                    return EmptyScreen();
                  }

                  List items = [];
                  items.addAll(docFolders);
                  items.addAll(files);

                  return Column(
                    children: [
                      if (!viewAsList)
                        Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                            ),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onLongPress: () =>
                                    showContextAction(items[index]),
                                onTap: () {
                                  if (items[index] is MyFile) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => FileView(
                                          file: items[index],
                                        ),
                                      ),
                                    );
                                  } else if (items[index]
                                      is CollectionReference) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => FileScreen(
                                          folder: items[index],
                                        ),
                                      ),
                                    );
                                  } else {
                                    alert(
                                      context,
                                      "Non registered type Collection nor MyFile",
                                    );
                                  }
                                },
                                child: GridTile(
                                  footer: Center(
                                    child: Text(
                                      items[index] is MyFile
                                          ? items[index].name.toString()
                                          : items[index].id.toString(),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Hero(
                                      tag: items[index] is MyFile
                                          ? items[index].name.toString()
                                          : items[index].id.toString(),
                                      child: Icon(
                                        items[index] is MyFile
                                            ? fileIcon(
                                                (items[index] as MyFile).name)
                                            : Icons.folder_rounded,
                                        size: 80,
                                        color: items[index] is MyFile
                                            ? fileIconColor(
                                                (items[index] as MyFile).name)
                                            : AppTheme.folderIcon,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      if (viewAsList)
                        Expanded(
                          child: ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              // MyFile file = files[index];
                              return ListTile(
                                leading: Icon(
                                  items[index] is MyFile
                                      ? fileIcon((items[index] as MyFile).name)
                                      : Icons.folder_rounded,
                                  color: items[index] is MyFile
                                      ? fileIconColor(
                                          (items[index] as MyFile).name)
                                      : AppTheme.folderIcon,
                                  size: 35,
                                ),
                                title: Text(
                                  items[index] is MyFile
                                      ? items[index].name.toString()
                                      : items[index].id.toString(),
                                ),
                                subtitle: items[index] is MyFile
                                    ? Text(
                                        (items[index].timestamp as DateTime)
                                            .formatDate(),
                                        style: TextStyle(
                                          color: AppTheme.bubble,
                                          fontSize: 12,
                                        ),
                                      )
                                    : null,
                                onLongPress: () =>
                                    showContextAction(items[index]),
                                onTap: () {
                                  if (items[index] is MyFile) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => FileView(
                                          file: items[index],
                                        ),
                                      ),
                                    );
                                  } else if (items[index]
                                      is CollectionReference) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => FileScreen(
                                          folder: items[index],
                                        ),
                                      ),
                                    );
                                  } else {
                                    alert(
                                      context,
                                      "Non registered type Collection nor MyFile",
                                    );
                                  }
                                },
                                trailing: items[index] is MyFile
                                    ? null
                                    : Icon(Icons.chevron_right_rounded),
                              );
                            },
                          ),
                        ),
                    ],
                  );
                }

                return LoadingScreen();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createFile(reference: widget.folder),
        child: Icon(Icons.file_upload_outlined),
      ),
    );
  }
}

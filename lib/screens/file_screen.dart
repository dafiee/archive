// ignore_for_file: curly_braces_in_flow_control_structures, use_build_context_synchronously

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
import 'package:archive/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final TextEditingController _filterController = TextEditingController();
  List items = [];
  List originalItems = [];
  // String folderPath = "Loading...";
  String? folderPath;

  void showContextAction(dynamic item, bool isFile) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      constraints: BoxConstraints(maxHeight: screenSize.height * .5),
      builder: (_) => MyContextMenuSheet(
        item: item,
        isFile: isFile,
        rootContext: context,
      ),
    );
  }

  void filter(String? keyword) {
    setState(() {
      if (keyword != null && keyword.isNotEmpty) {
        items = originalItems.where((item) {
          if (item is MyFile) {
            return item.name.toLowerCase().contains(keyword.toLowerCase());
          } else if (item is CollectionReference) {
            return item.id.toLowerCase().contains(keyword.toLowerCase());
          }
          return false;
        }).toList();
      } else {
        items = originalItems;
      }
    });
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

  /// Returns the path of the folder in a human-readable format.
  Future<String> getFolderPath(CollectionReference folder) async {
    List<String> parts = [];
    CollectionReference? current = folder;

    while (current != null) {
      parts.insert(0, current.id);
      final parentDoc = current.parent;
      if (parentDoc != null) {
        current = parentDoc.parent;
      } else {
        current = null;
      }
    }

    parts[0] = "Home"; // rename Firestore root collection to 'Home'

    // Truncate if too long
    if (parts.length > 3) {
      return "${parts.first} > … > ${parts.last}";
    }
    return parts.join(" > ");
  }

  Future<void> showFileOptions(BuildContext context, MyFile file) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("File Options"),
        content: Text("What do you want to do with ${file.name}?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text("Cancel")),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text("Delete")),
        ],
      ),
    );

    if (confirm == true) {
      deleteFile(context, file);
    }
  }

  Future<void> deleteFile(BuildContext context, MyFile file) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete File"),
        content: Text("Are you sure you want to delete ${file.name}?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text("Cancel")),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text("Delete")),
        ],
      ),
    );

    if (confirm == true) {
      // await file.ref.delete();
      await file.reference?.delete();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("File deleted.")));
    }
  }

  Future<void> renameFile(BuildContext context, MyFile file) async {
    final controller = TextEditingController(text: file.name);
    final newName = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Rename File"),
        content: TextField(controller: controller),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          TextButton(
              onPressed: () => Navigator.pop(ctx, controller.text.trim()),
              child: const Text("Rename")),
        ],
      ),
    );

    if (newName != null && newName != file.name) {
      // await file.ref.update({'name': newName});
      await file.reference?.update({'name': newName});
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("File renamed.")));
    }
  }

  @override
  void initState() {
    super.initState();

    getFolderPath(widget.folder).then((path) {
      setState(() {
        folderPath = path;
      });
    });
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
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    // Navigator.pushReplacementNamed(context, '/');
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                        (route) => false);
                  },
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
            controller: _filterController,
            hint: "Search in: ${folderPath ?? widget.folder.id}",
            prefix: Icons.search_rounded,
            onChange: filter,
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

                  // List items = [];
                  // items.addAll(docFolders);
                  // items.addAll(files);

                  originalItems.clear();
                  originalItems.addAll(docFolders);
                  originalItems.addAll(files);

                  if (_filterController.text.isEmpty) {
                    items = originalItems;
                  }

                  if (items.isEmpty) {
                    return const Expanded(
                      child: Center(
                        child: Text(
                          "No files or folders match your search.",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    );
                  }

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
                                onLongPress: () => showContextAction(
                                    items[index], items[index] is MyFile),
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
                                onLongPress: () => showContextAction(
                                    items[index], items[index] is MyFile),
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

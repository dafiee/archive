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
import 'package:archive/screens/file_screen.dart';
import 'package:archive/screens/loading_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<QueryDocumentSnapshot> folderList = [];
  List<CollectionReference> docFolders = [];
  List<MyFile> files = [];
  List items = [];
  List originalItems = [];

  final TextEditingController _filterController = TextEditingController();

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

  dynamic filter(String? keyword) {
    if (keyword != null && keyword.isNotEmpty) {
      items = originalItems.where((itemName) {
        bool resultsFiles = false;
        bool resultsFolders = false;

        if (itemName is MyFile) {
          resultsFiles = itemName.name.contains(keyword);
        } else if (itemName is CollectionReference) {
          resultsFiles = itemName.id.contains(keyword);
        }

        return resultsFiles || resultsFolders;
      }).toList();
    } else {
      items = originalItems;
    }
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Cloud Drive"),
        leading: Icon(
          Icons.archive,
          color: AppTheme.primary,
        ),
        actions: [
          IconButton(
            onPressed: () => createFile(withFolder: true),
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
            onChange: filter,
            controller: _filterController,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: MyFile.getRef().snapshots(),
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

                  originalItems.clear();
                  originalItems.addAll(docFolders);
                  originalItems.addAll(files);

                  items = originalItems;

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
                                            ? Icons.image_outlined
                                            : Icons.folder_rounded,
                                        size: 80,
                                        color: items[index] is MyFile
                                            ? Colors.blueGrey
                                            : Colors.amber[700],
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
                                      ? Icons.image_outlined
                                      : Icons.folder_rounded,
                                  color: items[index] is MyFile
                                      ? Colors.blueGrey
                                      : Colors.amber[700],
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
        onPressed: createFile,
        child: Icon(Icons.file_upload_outlined),
      ),
    );
  }
}

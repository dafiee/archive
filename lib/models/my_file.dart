// import 'package:archive/config/globals.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class MyFile {
//   final DocumentReference? reference;
//   final String name;
//   final String path;
//   Set<String> subFolderNames;
//   final DateTime timestamp;
//   static String baseSubFolderName = "folders";

//   MyFile({
//     this.reference,
//     required this.name,
//     required this.path,
//     this.subFolderNames = const {},
//     required this.timestamp,
//   });

//   MyFile.fromMap(Map<String, dynamic> map, DocumentReference ref)
//       : reference = ref,
//         name = map['name'],
//         path = map['path'],
//         subFolderNames = {},
//         timestamp = DateTime.fromMillisecondsSinceEpoch(
//           map['timestamp'],
//         );

//   Map<String, dynamic> toMap() {
//     return {
//       "name": name,
//       "path": path,
//       "subFolderNames": subFolderNames,
//       "timestamp": timestamp.millisecondsSinceEpoch,
//     };
//   }

//   static CollectionReference<Map<String, dynamic>> getRef() {
//     return firestore.collection('pilot');
//   }
// }

import 'package:archive/config/globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyFile {
  final DocumentReference? reference;
  final String name;
  final String path;
  final String userID;
  Set<String> subFolderNames;
  final DateTime timestamp;

  static String baseSubFolderName = "folders";

  MyFile({
    this.reference,
    required this.name,
    required this.path,
    required this.userID,
    this.subFolderNames = const {},
    required this.timestamp,
  });

  factory MyFile.fromMap(Map<String, dynamic> map, DocumentReference ref) {
    return MyFile(
      reference: ref,
      name: map['fileName'],
      path: map['downloadUrl'],
      userID: map['userID'],
      timestamp: (map['uploadedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "fileName": name,
      "downloadUrl": path,
      "userID": userID,
      "subFolderNames": subFolderNames,
      "uploadedAt": Timestamp.fromDate(timestamp),
    };
  }

  static CollectionReference<Map<String, dynamic>> getRef() {
    return firestore.collection('files');
  }
}

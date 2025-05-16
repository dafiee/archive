// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_filex/open_filex.dart';
import 'package:archive/models/my_file.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

Future<void> downloadFile(BuildContext context, MyFile file) async {
  try {
    // Request permission
    if (Platform.isAndroid) {
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Storage permission denied.")),
        );
        return;
      }
    }

    // Public Downloads directory
    final dir = Directory('/storage/emulated/0/Download');
    final safeName = sanitizeFileName(file.name); // Clean the file name
    final savePath = "${dir.path}/$safeName";

    // Debug prints
    debugPrint("📦 Downloading from: ${file.path}");
    debugPrint("📁 Saving to: $savePath");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("File downloading...")),
    );

    // Download using Dio
    await Dio().download(
      file.path,
      savePath,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          debugPrint(
              "📥 Progress: ${(received / total * 100).toStringAsFixed(1)}%");
        }
      },
    );

    // Notify success
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Download complete: $safeName")),
      );
    }

    // Open the file automatically
    final result = await OpenFilex.open(savePath);
    debugPrint("📂 OpenFilex result: ${result.message}");
  } catch (e) {
    debugPrint("❌ Download error: $e");
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Download failed: $e")),
      );
    }
  }
}

// Function to sanitize file names
String sanitizeFileName(String name) {
  return name.replaceAll(RegExp(r'''[\/\\:*?"<>|']'''), '_');
}

// Future<void> shareFile(MyFile file) async {
//   try {
//     final tempDir = await getTemporaryDirectory();
//     final tempPath = '${tempDir.path}/${sanitizeFileName(file.name)}';

//     await Dio().download(file.path, tempPath);

//     await Share.shareXFiles(
//       [XFile(tempPath)],
//       text: 'Sharing: ${file.name}',
//     );
//   } catch (e) {
//     debugPrint("❌ Share error: $e");
//   }
// }

Future<void> shareFile(BuildContext context, MyFile file) async {
  try {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    // Create temp directory
    final tempDir = await getTemporaryDirectory();
    final tempPath = '${tempDir.path}/${sanitizeFileName(file.name)}';

    // Download file
    await Dio().download(file.path, tempPath);

    // Dismiss loading dialog before opening share sheet
    Navigator.of(context).pop();

    // Share the file
    await Share.shareXFiles(
      [XFile(tempPath)],
      text: 'Sharing: ${file.name}',
    );
  } catch (e) {
    debugPrint("❌ Share error: $e");
    if (context.mounted) {
      Navigator.of(context).pop(); // Ensure dialog is closed on error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Share failed: $e")),
      );
    }
  }
}

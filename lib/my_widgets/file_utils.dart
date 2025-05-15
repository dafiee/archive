// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_filex/open_filex.dart';
import 'package:archive/models/my_file.dart';

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

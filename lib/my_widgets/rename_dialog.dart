// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import '../models/my_file.dart';

Future<void> renameFile(BuildContext context, MyFile file) async {
  final controller = TextEditingController(text: file.name);

  final newName = await showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text("Rename File"),
      content: TextField(controller: controller),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, controller.text.trim()),
          child: const Text("Rename"),
        ),
      ],
    ),
  );

  if (newName != null && newName != file.name && newName.isNotEmpty) {
    if (file.reference != null) {
      await file.reference!.update({'name': newName});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("File renamed.")),
      );
    }
  }
}

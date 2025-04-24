import 'package:archive/config/globals.dart';
import 'package:archive/config/theme.dart';
import 'package:flutter/material.dart';

class ErrorScreen extends StatefulWidget {
  final String errorMessage;
  const ErrorScreen({
    super.key,
    this.errorMessage = "Oops! I hit a wall",
  });

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.sync_problem_rounded,
            size: 100,
            color: AppTheme.error,
          ),
          SizedBox(
            width: screenSize.width * .8,
            child: Text(
              widget.errorMessage,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

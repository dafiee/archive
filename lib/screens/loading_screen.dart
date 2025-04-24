import 'package:archive/config/globals.dart';
import 'package:archive/config/theme.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingScreen extends StatefulWidget {
  final String loadingMessage;

  const LoadingScreen({
    super.key,
    this.loadingMessage = "Hang tight, pulling your data...",
  });

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 100,
            child: LoadingIndicator(
              indicatorType: Indicator.ballClipRotateMultiple,
              strokeWidth: 5,
              colors: [
                AppTheme.primary,
              ],
            ),
          ),
          SizedBox(
            width: screenSize.width * .8,
            child: Text(
              widget.loadingMessage,
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}

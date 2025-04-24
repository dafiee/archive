import 'package:archive/config/theme.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

void showPreloader(BuildContext context, String title,
    {bool poppable = false}) {
  showDialog(
    context: context,
    barrierDismissible: poppable,
    builder: (_) => PopScope(
      canPop: poppable,
      child: AlertDialog(
        icon: Icon(
          Icons.hourglass_bottom_rounded,
          size: 50,
          color: AppTheme.primary,
        ),
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 100,
              child: Center(
                // child: CircularProgressIndicator(),
                child: LoadingIndicator(
                  indicatorType: Indicator.ballClipRotateMultiple,
                  strokeWidth: 5,
                  colors: [
                    AppTheme.primary,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

alertSuccessPreloader(BuildContext context, String title) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      icon: Icon(
        Icons.check_circle_rounded,
        size: 50,
        color: Colors.green[700],
      ),
      title: Text(title),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("OK"),
        ),
      ],
    ),
  );
}

alertSuccessPreloaderFunction(
    BuildContext context, String title, Function function,
    {bool isDumm = true, bool hasCancelButton = true, bool poppable = false}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => PopScope(
      canPop: poppable,
      child: AlertDialog(
        icon: Icon(
          isDumm ? Icons.check_circle_rounded : Icons.error_outline_rounded,
          size: 50,
          color: isDumm ? Colors.green[700] : Colors.blue[700],
        ),
        title: Text(title),
        actions: [
          if (hasCancelButton)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: AppTheme.bubble,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              function();
            },
            child: Text(
              "Okay",
              style: TextStyle(
                color: AppTheme.success,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

alert(BuildContext context, String message, {String? title}) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      icon: Icon(
        Icons.warning_amber_rounded,
        color: AppTheme.error,
        size: 50,
      ),
      title: Text(title ?? "Alert!"),
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Okay"),
        ),
      ],
    ),
  );
}

alertFunction(BuildContext context, String title, Function function,
    {bool isWarning = true,
    String? message,
    bool hasCancelButton = true,
    String? actionText}) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      icon: Icon(
        isWarning ? Icons.warning_amber_rounded : Icons.info_outline_rounded,
        color: isWarning ? AppTheme.warning : AppTheme.info,
        size: 50,
      ),
      title: Text(title),
      content: message != null
          ? Text(
              message,
              textAlign: TextAlign.center,
            )
          : null,
      actions: [
        if (hasCancelButton)
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Cancel",
              style: TextStyle(
                color: AppTheme.bubble,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            function();
          },
          child: Text(
            actionText ?? "Okay",
            style: TextStyle(color: AppTheme.error),
          ),
        ),
      ],
    ),
  );
}

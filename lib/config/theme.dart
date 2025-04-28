import 'package:flutter/material.dart';

abstract class AppTheme {
  //colors
  static Color primary = Colors.blue;
  // static Color primary = Colors.blueAccent;
  static Color error = Colors.red;
  static Color warning = Colors.amber;
  static Color info = Colors.blue;
  static Color success = Colors.green;
  static Color bubble = Colors.grey.withValues(alpha: .5);

  /// the one color for all folder icons:
  static const Color folderIcon = Colors.blue;

  //text
  static TextStyle normal = TextStyle(
    fontSize: 14,
  );
  static TextStyle medium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );
  static TextStyle large = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );
  static TextStyle xLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );

  //spacing
  static double sNormal = 8;
  static double sMedium = 12;
  static double sLarge = 16;
  static double sxLarge = 20;
}

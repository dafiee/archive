import 'package:archive/config/globals.dart';
import 'package:archive/config/theme.dart';
import 'package:archive/firebase_options.dart';
import 'package:archive/screens/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  screenSize = MediaQueryData.fromView(
    WidgetsBinding.instance.platformDispatcher.implicitView!,
  ).size;

  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((val) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppTheme.primary,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppTheme.primary,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:archive/config/globals.dart';
import 'package:archive/config/theme.dart';
import 'package:archive/screens/home.dart';
import 'package:archive/screens/login_screen.dart';
import 'package:archive/screens/sign_up_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  screenSize = MediaQueryData.fromView(
    WidgetsBinding.instance.platformDispatcher.implicitView!,
  ).size;

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // <-- this disables the debug banner
      title: 'Archive App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppTheme.primary),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppTheme.primary,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/signup': (_) => const SignUpScreen(),
        '/home': (context) => const Home(),
      },
    );
  }
}

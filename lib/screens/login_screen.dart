// Created by: Emm
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;
  bool _obscurePassword = true;
  String? error;

  final List<AnimationController> _controllers = [];
  final List<Animation<Offset>> _animations = [];
  final int _folderCount = 10;

  Future<void> signInWithGoogle() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        await FirebaseAuth.instance.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) {
          setState(() => isLoading = false);
          return;
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await FirebaseAuth.instance.signInWithCredential(credential);
      }

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      setState(() => error = "Google Sign-In failed: $e");
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < _folderCount; i++) {
      final controller = AnimationController(
        duration: const Duration(seconds: 3),
        vsync: this,
      );

      final animation = Tween<Offset>(
        begin: Offset((Random().nextDouble() * 0.8) - 0.2, 0.5),
        end: Offset((Random().nextDouble() * 0.04) - 0.1, -0.9),
      ).animate(
        CurvedAnimation(
          parent: controller,
          curve: Interval(i * 0.1, 1.0, curve: Curves.easeInOut),
        ),
      );

      _controllers.add(controller);
      _animations.add(animation);

      Future.delayed(Duration(milliseconds: 400 * i), () {
        if (mounted) controller.repeat(reverse: true);
      });
    }
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> loginUser() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } on FirebaseAuthException catch (e) {
      // Log for your benefit:
      debugPrint('FirebaseAuth error [${e.code}]: ${e.message}');

      // Map specific error codes to friendlier text:
      String friendly;
      switch (e.code) {
        case 'invalid-email':
        case 'user-disabled':
        case 'user-not-found':
        case 'wrong-password':
          friendly = e.message ?? 'Invalid email or password.';
          break;
        default:
          friendly = 'Login failed. Please try again.';
      }

      setState(() => error = friendly);
    } catch (e) {
      // This will catch network errors, JSON parse errors, etc.
      debugPrint('Unexpected login error: $e');
      setState(
          () => error = 'Login failed. Check your connection and try again.');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> loginAsGuest() async {
    await FirebaseAuth.instance.signInAnonymously();
    // ignore: use_build_context_synchronously
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      // body: SafeArea(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Top cloud mask
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  // height: 0,
                  decoration: const BoxDecoration(
                    // color: Colors.blue,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(50),
                    ),
                  ),
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      // child: Icon(Icons.cloud, size: 190, color: Colors.white),
                      child: Image.asset(
                        'images/logo.png',
                        width: 190,
                        height: 190,
                        fit: BoxFit.contain,
                      )),
                ),
              ),

              // Welcome text
              Positioned(
                // top: 210,
                left: 0,
                right: 0,
                child: Column(
                  children: const [
                    SizedBox(height: 50),
                    Text(
                      "Welcome to",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Archive",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        // color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Access your personal cloud storage.",
                      // style: TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Login form (with dynamic padding for keyboard)
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Email TextField
                    TextField(
                      controller: _emailController,
                      // style: const TextStyle(color: Colors.white),
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_) {
                        // Move focus to the password field
                        FocusScope.of(context).nextFocus();
                      },
                      decoration: InputDecoration(
                        labelText: "Email",
                        // hintStyle: const TextStyle(color: Colors.white54),
                        filled: true,
                        fillColor: Colors.white12,
                        prefixIcon: const Icon(
                          Icons.email_outlined, /*color: Colors.white*/
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Password TextField
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => loginUser(),
                      decoration: InputDecoration(
                        labelText: "Password",
                        filled: true,
                        fillColor: Colors.white12,
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            // color: Colors.white70,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      // style: const TextStyle(color: Colors.white),
                    ),

                    // ....
                    const SizedBox(height: 16),
                    if (error != null)
                      Card(
                        color: Colors.red.shade50,
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline,
                                  color: Colors.red),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  error!,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    // Login button
                    const SizedBox(height: 16),
                    isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : ElevatedButton(
                            onPressed: loginUser,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.blue,
                              minimumSize: const Size.fromHeight(50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text("Login"),
                          ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: signInWithGoogle,
                      icon: Image.asset('images/google_logo.png',
                          height: 24, width: 24),
                      label: const Text("Sign in with Google"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     const Text(
                    //       "Don’t have an account?",
                    //       // style: TextStyle(color: Colors.white70),
                    //     ),
                    //     TextButton(
                    //       onPressed: () {
                    //         Navigator.pushNamed(context, '/signup');
                    //       },
                    //       child: const Text(
                    //         "Sign up",
                    //         style: TextStyle(
                    //           // color: Colors.white,
                    //           fontWeight: FontWeight.bold,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      //),
    );
  }
}

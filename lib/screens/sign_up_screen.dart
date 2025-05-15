import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailCtl = TextEditingController();
  final _passCtl = TextEditingController();
  final _confirmCtl = TextEditingController();
  bool isLoading = false;
  bool _hidePass = true;
  String? error;

  Future<void> signUp() async {
    final email = _emailCtl.text.trim();
    final pass = _passCtl.text.trim();
    final confirm = _confirmCtl.text.trim();

    // 1) blank-field validation
    if (email.isEmpty || pass.isEmpty || confirm.isEmpty) {
      setState(() => error = "Please fill in all fields.");
      return;
    }

    // 2) password match validation
    if (pass != confirm) {
      setState(() => error = "Passwords don’t match.");
      return;
    }

    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pass);

      await userCredential.user?.sendEmailVerification();

      await FirebaseAuth.instance.signOut();

      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Verify your email"),
          content: const Text(
              "A verification link has been sent to your email. Please verify and log in again."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            )
          ],
        ),
      );
    } on FirebaseAuthException catch (e) {
      // 3) map the most common codes to friendly messages
      switch (e.code) {
        case 'email-already-in-use':
          error = "That email is already in use.";
          break;
        case 'invalid-email':
          error = "That email address is invalid.";
          break;
        case 'weak-password':
          error = "Choose a stronger password (6+ characters).";
          break;
        case 'network-request-failed':
          error = "Network error—please try again.";
          break;
        default:
          error = e.message;
      }
      setState(() {});
    } catch (e) {
      // 4) any other error
      setState(() => error = "Signup failed. Please try again.");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailCtl.dispose();
    _passCtl.dispose();
    _confirmCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blue,
      body: SafeArea(
        child: Stack(
          children: [
            // Cloud Header
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                  height: 250,
                  decoration: const BoxDecoration(
                    // color: Colors.blue,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(50),
                    ),
                  ),
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Image.asset(
                        'images/logo.png',
                        width: 190,
                        height: 190,
                        fit: BoxFit.contain,
                      ))),
            ),

            // Registration form
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 270, 32, 32),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text(
                      "Create an account",
                      style: TextStyle(
                        fontSize: 28, /*color: Colors.white*/
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _emailCtl,
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
                      // style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passCtl,
                      obscureText: _hidePass,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                        filled: true,
                        fillColor: Colors.white12,
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _hidePass ? Icons.visibility_off : Icons.visibility,
                            // color: Colors.white70,
                          ),
                          onPressed: () {
                            setState(() {
                              _hidePass = !_hidePass;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      // style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _confirmCtl,
                      obscureText: _hidePass,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        labelText: "Confirm password",
                        filled: true,
                        fillColor: Colors.white12,
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _hidePass ? Icons.visibility_off : Icons.visibility,
                            // color: Colors.white70,
                          ),
                          onPressed: () {
                            setState(() {
                              _hidePass = !_hidePass;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      // style: const TextStyle(color: Colors.white),
                    ),
                    if (error != null) ...[
                      const SizedBox(height: 12),
                      Card(
                        color: Colors.red.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline,
                                  color: Colors.red),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(error!,
                                    style: const TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : ElevatedButton(
                            onPressed: signUp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.blue,
                              minimumSize: const Size.fromHeight(50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text("Create account"),
                          ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Back to login",
                        // style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});
//   @override
//   // ignore: library_private_types_in_public_api
//   _SignUpScreenState createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   final _emailCtl = TextEditingController();
//   final _passCtl = TextEditingController();
//   final _confirmCtl = TextEditingController();
//   bool isLoading = false;
//   String? error;

//   Future<void> signUp() async {
//     final email = _emailCtl.text.trim();
//     final pass = _passCtl.text.trim();
//     final confirm = _confirmCtl.text.trim();

//     if (pass != confirm) {
//       setState(() => error = "Passwords don’t match");
//       return;
//     }

//     setState(() {
//       isLoading = true;
//       error = null;
//     });

//     try {
//       await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: email,
//         password: pass,
//       );
//       if (mounted) Navigator.pushReplacementNamed(context, '/home');
//     } on FirebaseAuthException catch (e) {
//       setState(() => error = e.message);
//     } catch (e) {
//       setState(() => error = "Signup failed. Try again.");
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blue,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 32),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text(
//                 "Create an account",
//                 style: TextStyle(fontSize: 28, color: Colors.white),
//               ),
//               const SizedBox(height: 24),
//               TextField(
//                 controller: _emailCtl,
//                 decoration: InputDecoration(
//                   hintText: "Email",
//                   fillColor: Colors.white12,
//                   filled: true,
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                 ),
//                 style: const TextStyle(color: Colors.white),
//                 keyboardType: TextInputType.emailAddress,
//                 textInputAction: TextInputAction.next,
//               ),
//               const SizedBox(height: 16),
//               TextField(
//                 controller: _passCtl,
//                 decoration: InputDecoration(
//                   hintText: "Password",
//                   fillColor: Colors.white12,
//                   filled: true,
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                 ),
//                 style: const TextStyle(color: Colors.white),
//                 obscureText: true,
//                 textInputAction: TextInputAction.next,
//               ),
//               const SizedBox(height: 16),
//               TextField(
//                 controller: _confirmCtl,
//                 decoration: InputDecoration(
//                   hintText: "Confirm password",
//                   fillColor: Colors.white12,
//                   filled: true,
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                 ),
//                 style: const TextStyle(color: Colors.white),
//                 obscureText: true,
//                 textInputAction: TextInputAction.done,
//                 onSubmitted: (_) => signUp(),
//               ),
//               if (error != null)
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                   child: Text(error!,
//                       style: const TextStyle(color: Colors.redAccent)),
//                 ),
//               const SizedBox(height: 16),
//               isLoading
//                   ? const CircularProgressIndicator(color: Colors.white)
//                   : ElevatedButton(
//                       onPressed: signUp,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.white,
//                         foregroundColor: Colors.blue,
//                         minimumSize: const Size.fromHeight(50),
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12)),
//                       ),
//                       child: const Text("Create account"),
//                     ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});
//   @override
//   _SignUpScreenState createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   final _emailCtl = TextEditingController();
//   final _passCtl = TextEditingController();
//   final _confirmCtl = TextEditingController();
//   bool isLoading = false;
//   String? error;

//   Future<void> signUp() async {
//     final email = _emailCtl.text.trim();
//     final pass = _passCtl.text.trim();
//     final confirm = _confirmCtl.text.trim();

//     if (pass != confirm) {
//       setState(() => error = "Passwords don’t match");
//       return;
//     }

//     setState(() {
//       isLoading = true;
//       error = null;
//     });

//     try {
//       await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: email,
//         password: pass,
//       );
//       if (mounted) Navigator.pushReplacementNamed(context, '/home');
//     } on FirebaseAuthException catch (e) {
//       // Map common error codes to friendly messages
//       switch (e.code) {
//         case 'email-already-in-use':
//           error = "That email is already registered.";
//           break;
//         case 'invalid-email':
//           error = "That email address is invalid.";
//           break;
//         case 'weak-password':
//           error = "Choose a stronger password (6+ chars).";
//           break;
//         case 'network-request-failed':
//           error = "Network error, please try again.";
//           break;
//         default:
//           error = e.message;
//       }
//       setState(() {});
//     } catch (e) {
//       setState(() => error = "Signup failed. Please try again.");
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   @override
//   void dispose() {
//     _emailCtl.dispose();
//     _passCtl.dispose();
//     _confirmCtl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blue,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 32),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text(
//                 "Create an account",
//                 style: TextStyle(fontSize: 28, color: Colors.white),
//               ),
//               const SizedBox(height: 24),
//               TextField(
//                 controller: _emailCtl,
//                 decoration: InputDecoration(
//                   hintText: "Email",
//                   fillColor: Colors.white12,
//                   filled: true,
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                 ),
//                 style: const TextStyle(color: Colors.white),
//                 keyboardType: TextInputType.emailAddress,
//                 textInputAction: TextInputAction.next,
//                 onSubmitted: (_) => FocusScope.of(context).nextFocus(),
//               ),
//               const SizedBox(height: 16),
//               TextField(
//                 controller: _passCtl,
//                 decoration: InputDecoration(
//                   hintText: "Password",
//                   fillColor: Colors.white12,
//                   filled: true,
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                 ),
//                 style: const TextStyle(color: Colors.white),
//                 obscureText: true,
//                 textInputAction: TextInputAction.next,
//                 onSubmitted: (_) => FocusScope.of(context).nextFocus(),
//               ),
//               const SizedBox(height: 16),
//               TextField(
//                 controller: _confirmCtl,
//                 decoration: InputDecoration(
//                   hintText: "Confirm password",
//                   fillColor: Colors.white12,
//                   filled: true,
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                 ),
//                 style: const TextStyle(color: Colors.white),
//                 obscureText: true,
//                 textInputAction: TextInputAction.done,
//                 onSubmitted: (_) => signUp(),
//               ),

//               // error card
//               if (error != null)
//                 Card(
//                   color: Colors.red.shade50,
//                   margin: const EdgeInsets.symmetric(vertical: 12),
//                   child: Padding(
//                     padding: const EdgeInsets.all(12),
//                     child: Row(
//                       children: [
//                         const Icon(Icons.error_outline, color: Colors.red),
//                         const SizedBox(width: 8),
//                         Expanded(
//                           child: Text(
//                             error!,
//                             style: const TextStyle(color: Colors.red),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//               const SizedBox(height: 16),
//               isLoading
//                   ? const CircularProgressIndicator(color: Colors.white)
//                   : ElevatedButton(
//                       onPressed: signUp,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.white,
//                         foregroundColor: Colors.blue,
//                         minimumSize: const Size.fromHeight(50),
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12)),
//                       ),
//                       child: const Text("Create account"),
//                     ),
//               const SizedBox(height: 12),
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text(
//                   "Back to login",
//                   style: TextStyle(color: Colors.white70),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

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
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
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
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Create an account",
                style: TextStyle(fontSize: 28, color: Colors.white),
              ),
              const SizedBox(height: 24),

              // — Email —
              TextField(
                controller: _emailCtl,
                decoration: InputDecoration(
                  hintText: "Email",
                  fillColor: Colors.white12,
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onSubmitted: (_) => FocusScope.of(context).nextFocus(),
              ),
              const SizedBox(height: 16),

              // — Password —
              TextField(
                controller: _passCtl,
                decoration: InputDecoration(
                  hintText: "Password",
                  fillColor: Colors.white12,
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                style: const TextStyle(color: Colors.white),
                obscureText: true,
                textInputAction: TextInputAction.next,
                onSubmitted: (_) => FocusScope.of(context).nextFocus(),
              ),
              const SizedBox(height: 16),

              // — Confirm —
              TextField(
                controller: _confirmCtl,
                decoration: InputDecoration(
                  hintText: "Confirm password",
                  fillColor: Colors.white12,
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                style: const TextStyle(color: Colors.white),
                obscureText: true,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => signUp(),
              ),

              // — Error Card —
              if (error != null)
                Card(
                  color: Colors.red.shade50,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red),
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

              const SizedBox(height: 16),

              // — Create Account Button —
              isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : ElevatedButton(
                      onPressed: signUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blue,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Create account"),
                    ),

              const SizedBox(height: 12),

              // — Back to Login —
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Back to login",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

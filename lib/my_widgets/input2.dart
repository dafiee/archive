// import 'package:flutter/material.dart';
// import 'package:ade/config/theme_config.dart';

// class MyInput extends StatefulWidget {
//   final String? label;
//   final String? hint;
//   final Widget? child;
//   final Color? background;
//   final FocusNode? focusNode;
//   final TextInputType? inputType;
//   final TextEditingController? controller;
//   final AutovalidateMode? autovalidateMode;
//   final String? Function(String?)? validator;
//   final Function(String?)? onChange;
//   final Function(String?)? onSave;
//   final IconData? prefix;
//   final Widget? suffix;
//   final bool isPassword;
//   final bool isThreeLine;

//   const MyInput({
//     super.key,
//     this.label,
//     this.hint,
//     this.child,
//     this.focusNode,
//     this.background,
//     this.inputType,
//     this.autovalidateMode,
//     this.validator,
//     this.prefix,
//     this.isThreeLine = false,
//     this.suffix,
//     this.isPassword = false,
//     this.controller,
//     this.onChange,
//     this.onSave,
//   });

//   @override
//   State<MyInput> createState() => _MyInputState();
// }

// class _MyInputState extends State<MyInput> {
//   late bool togglePasswordView;

//   void tooglePasswordVisibility() {
//     setState(() {
//       togglePasswordView = !togglePasswordView;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     togglePasswordView = widget.isPassword;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: margin),
//       padding: const EdgeInsets.symmetric(horizontal: padding),
//       decoration: BoxDecoration(
//         color: widget.background ?? bubbleColorGrey,
//         borderRadius: BorderRadius.circular(radiusL),
//       ),
//       child: TextFormField(
//         controller: widget.controller,
//         obscureText: togglePasswordView,
//         keyboardType: widget.inputType,
//         validator: widget.validator,
//         onChanged: widget.onChange,
//         onSaved: widget.onSave,
//         focusNode: widget.focusNode,
//         autovalidateMode: widget.autovalidateMode,
//         minLines: widget.isThreeLine && !widget.isPassword ? 4 : 1,
//         maxLines: widget.isThreeLine && !widget.isPassword ? 10 : 1,
//         decoration: InputDecoration(
//           focusColor: primarySwatch.shade100,
//           border: InputBorder.none,
//           hintText: widget.hint,
//           label: widget.label != null ? Text(widget.label!) : null,
//           prefixIcon: widget.prefix == null
//               ? null
//               : Icon(
//                   widget.prefix,
//                   color: primaryColor,
//                 ),
//           suffixIcon: widget.isPassword
//               ? IconButton(
//                   onPressed: tooglePasswordVisibility,
//                   icon: Icon(
//                     togglePasswordView
//                         ? Icons.visibility
//                         : Icons.visibility_off_rounded,
//                   ),
//                 )
//               : widget.suffix,
//           errorStyle: const TextStyle(
//             color: errorColor,
//           ),
//         ),
//       ),
//     );
//   }
// }

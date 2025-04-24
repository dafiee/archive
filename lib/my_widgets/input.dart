import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:archive/config/theme.dart';

class MyInput extends StatefulWidget {
  final String? label;
  final String? hint;
  final Widget? child;
  final Color? background;
  final FocusNode? focusNode;
  final TextInputType? inputType;
  final TextEditingController? controller;
  final List<TextInputFormatter> textInputFormatter;
  final AutovalidateMode? autovalidateMode;
  final String? Function(String?)? validator;
  final Function(String?)? onChange;
  final Function(String?)? onSave;
  final IconData? prefix;
  final Widget? suffix;
  final bool isPassword;
  final bool isThreeLine;
  final bool hasRadius;
  final bool hasBorder;
  final bool isSmall;
  final bool isReadOnly;
  final bool autoFocus;

  const MyInput({
    super.key,
    this.label,
    this.hint,
    this.child,
    this.focusNode,
    this.background,
    this.inputType,
    this.autovalidateMode,
    this.validator,
    this.prefix,
    this.isThreeLine = false,
    this.suffix,
    this.isPassword = false,
    this.controller,
    this.onChange,
    this.onSave,
    this.hasRadius = true,
    this.isSmall = false,
    this.hasBorder = true,
    this.isReadOnly = false,
    this.autoFocus = false,
    this.textInputFormatter = const [],
  });

  @override
  State<MyInput> createState() => _MyInputState();
}

class _MyInputState extends State<MyInput> {
  late bool togglePasswordView;

  void tooglePasswordVisibility() {
    setState(() {
      togglePasswordView = !togglePasswordView;
    });
  }

  @override
  void initState() {
    super.initState();
    togglePasswordView = widget.isPassword;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.isSmall
          ? EdgeInsets.only(top: AppTheme.sNormal)
          : EdgeInsets.all(AppTheme.sNormal),
      padding: !widget.hasBorder
          ? EdgeInsets.all(AppTheme.sNormal)
          // ? const EdgeInsets.symmetric(horizontal: padding)
          : null,
      decoration: BoxDecoration(
          // color: widget.hasBorder ? null : widget.background ?? AppTheme.primary,
          // borderRadius:
          //     widget.hasRadius ? BorderRadius.circular(AppTheme.sxLarge) : null,
          ),
      child: TextFormField(
        autofocus: widget.autoFocus,
        readOnly: widget.isReadOnly,
        textCapitalization: TextCapitalization.sentences,
        style: TextStyle(
          fontSize: widget.isSmall ? 12 : null,
          fontWeight: FontWeight.normal,
        ),
        controller: widget.controller,
        obscureText: togglePasswordView,
        keyboardType: widget.inputType,
        validator: widget.validator,
        onChanged: widget.onChange,
        onSaved: widget.onSave,
        focusNode: widget.focusNode,
        autovalidateMode: widget.autovalidateMode,
        inputFormatters: widget.textInputFormatter,
        minLines: widget.isThreeLine && !widget.isPassword ? 1 : 1,
        maxLines: widget.isThreeLine && !widget.isPassword ? 10 : 1,
        decoration: InputDecoration(
          isDense: widget.isSmall,
          border: widget.hasBorder
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.sLarge),
                )
              : InputBorder.none,
          hintText: widget.hint,
          label: widget.label != null ? Text(widget.label!) : null,
          prefixIcon: widget.prefix == null
              ? null
              : Icon(
                  widget.prefix,
                  // color: AppTheme.primaryColor,
                ),
          suffixIcon: widget.isPassword
              ? IconButton(
                  onPressed: tooglePasswordVisibility,
                  icon: Icon(
                    togglePasswordView
                        ? Icons.visibility
                        : Icons.visibility_off_rounded,
                  ),
                )
              : widget.suffix,
          errorStyle: TextStyle(
            color: AppTheme.error,
          ),
        ),
      ),
    );
  }
}

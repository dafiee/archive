import 'package:flutter/material.dart';
import 'package:archive/config/theme.dart';

class MyButton extends StatelessWidget {
  final String? label;
  final VoidCallback? onPressedAction;
  final Widget? child;
  final Color? color;
  final Color? textColor;
  final LinearGradient? gradient;
  final IconData? leadingIcon;
  final double? width;
  final double? height;
  final double? elevation;
  final bool hasMargin;
  final bool hasRadius;
  final bool isActive;

  const MyButton({
    super.key,
    required this.onPressedAction,
    this.label,
    this.color,
    this.textColor,
    this.leadingIcon,
    this.gradient,
    this.hasMargin = true,
    this.hasRadius = true,
    this.isActive = false,
    // = const LinearGradient(
    //   colors: <Color>[
    //     Color(0xFF680000),
    //     Color(0xFFDA4C4C),
    //   ],
    // ),
    this.child,
    this.width,
    this.height,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Container(
        margin:
            hasMargin ? EdgeInsets.symmetric(vertical: AppTheme.sMedium) : null,
        width: width ?? size.width * .6,
        height: height,
        decoration: BoxDecoration(
          // color: isActive ? Colors.white : color ?? primaryColor,
          color: onPressedAction == null
              ? AppTheme.bubble
              : color ?? AppTheme.primary,
          // gradient: color == null ? gradient : null,
          borderRadius:
              hasRadius ? BorderRadius.circular(AppTheme.sNormal) : null,
        ),
        child: MaterialButton(
          onPressed: onPressedAction,
          padding: EdgeInsets.all(AppTheme.sNormal + 2),
          // fillColor: onPressedAction == null ? bubbleColor : color,
          elevation: elevation ?? 8,
          shape: hasRadius
              ? RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.sNormal),
                )
              : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // mainAxisAlignment: leadingIcon != null
            //     ? MainAxisAlignment.start
            //     : MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  if (isActive)
                    Container(
                      width: 3,
                      height: 25,
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                      ),
                    ),
                  if (leadingIcon != null)
                    SizedBox(
                      width: AppTheme.sNormal,
                    ),
                  if (leadingIcon != null)
                    Icon(
                      leadingIcon,
                      color: textColor ?? Colors.white,
                    ),
                  if (leadingIcon != null)
                    SizedBox(
                      width: AppTheme.sLarge,
                    ),
                  child ??
                      Text(
                        label ?? "",
                        style: AppTheme.medium.copyWith(
                          color: textColor ?? Colors.amber[50],
                        ),
                      ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

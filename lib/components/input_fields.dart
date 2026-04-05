import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'
    show
        BorderRadius,
        BorderSide,
        BuildContext,
        Color,
        Colors,
        FontWeight,
        Icon,
        IconData,
        InputDecoration,
        OutlineInputBorder,
        TextDecoration,
        TextEditingController,
        TextFormField,
        TextInputType,
        TextStyle,
        Theme,
        Widget;

class InputFields extends StatelessWidget {
  const InputFields({
    super.key,
    this.hint_text,
    this.borderRadius,
    required this.hintCoolor,
    required this.fontSize,
    this.googleFont,
    this.icon,
    this.fillColor,
    this.borderSide,
    this.controller,
    this.validator,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
    this.decoration,
  });

  final String? hint_text;
  final BorderRadius? borderRadius;
  final Color hintCoolor;
  final double fontSize;
  final TextStyle Function({
    required double fontSize,
    required Color color,
    required FontWeight fontWeight,
    required TextDecoration decoration,
  })?
  googleFont;
  final IconData? icon;
  final Color? fillColor;
  final BorderSide? borderSide;
  final InputDecoration? decoration;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    final inputTheme = Theme.of(context).inputDecorationTheme;

    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration:
          decoration ??
          InputDecoration(
            hintText: hint_text ?? '',
            prefixIcon: icon != null ? Icon(icon) : null,
            suffixIcon: suffixIcon,
            hintStyle:
                googleFont != null
                    ? googleFont!(
                      fontSize: fontSize,
                      color: hintCoolor,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                    )
                    : TextStyle(color: hintCoolor, fontSize: fontSize),
            filled: true,
            fillColor: fillColor ?? inputTheme.fillColor,
            border: OutlineInputBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(10),
              borderSide:
                  borderSide ?? const BorderSide(color: Colors.blue, width: 2),
            ),
          ),
    );
  }
}

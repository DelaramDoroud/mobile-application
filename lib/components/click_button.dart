import 'package:flutter/material.dart';

class ClickButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Icon? icon;
  final Color? textColor;

  const ClickButton({
    super.key,
    required this.text,
    required this.isLoading,
    required this.onPressed,
    required this.backgroundColor,
    this.icon,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.width * 0.04,
        ),
      ),
      onPressed: isLoading ? null : onPressed,
      child:
          isLoading
              ? const CircularProgressIndicator()
              : Text(
                text,
                style: TextStyle(fontWeight: FontWeight.bold, color: textColor, fontSize: 15),
              ),
    );
  }
}

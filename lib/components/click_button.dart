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
    final theme = Theme.of(context);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor ?? theme.colorScheme.onPrimary,
        padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.width * 0.04,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: 0,
      ),
      onPressed: isLoading ? null : onPressed,
      child:
          isLoading
              ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: textColor ?? theme.colorScheme.onPrimary,
                ),
              )
              : Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  fontSize: 15,
                ),
              ),
    );
  }
}

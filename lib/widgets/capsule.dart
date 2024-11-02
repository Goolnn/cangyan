import 'package:flutter/material.dart';

class Capsule extends StatelessWidget {
  final String text;

  final Color? backgroundColor;
  final Color? textColor;

  const Capsule(
    this.text, {
    super.key,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const StadiumBorder(),
      color: backgroundColor ?? Colors.black.withOpacity(0.25),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 4.0,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13.0,
            color: textColor ?? Colors.white,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class Capsule extends StatelessWidget {
  final Text text;

  final Color? backgroundColor;

  const Capsule(
    this.text, {
    super.key,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const StadiumBorder(),
      color: backgroundColor ?? Colors.black.withOpacity(0.25),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 6.0,
        ),
        child: DefaultTextStyle(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13.0,
          ),
          child: text,
        ),
      ),
    );
  }
}

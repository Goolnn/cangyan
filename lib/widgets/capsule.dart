import 'package:flutter/material.dart';

class Capsule extends StatelessWidget {
  final Color? color;
  final Widget child;

  const Capsule({
    super.key,
    this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const StadiumBorder(),
      color: color ?? Colors.black.withOpacity(0.25),
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
          child: child,
        ),
      ),
    );
  }
}

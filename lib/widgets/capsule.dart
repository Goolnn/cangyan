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
      color: color ?? Colors.black.withValues(alpha: 0.35),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 4.0,
        ),
        child: DefaultTextStyle(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10.0,
          ),
          child: child,
        ),
      ),
    );
  }
}

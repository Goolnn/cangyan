import 'package:flutter/material.dart';

class Progress extends StatelessWidget {
  final double value;

  const Progress(this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    Color foregroundColor;

    if (value != 1.0) {
      foregroundColor = Colors.grey;
    } else {
      foregroundColor = Colors.lightGreen;
    }

    return SizedBox(
      width: 16.0,
      height: 16.0,
      child: CircularProgressIndicator(
        backgroundColor: Colors.grey.withValues(alpha: 0.35),
        color: foregroundColor,
        value: value,
      ),
    );
  }
}

import 'package:flutter/material.dart';

class Progress extends StatelessWidget {
  final double value;

  const Progress(this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 16.0,
      height: 16.0,
      child: CircularProgressIndicator(
        value: value,
      ),
    );
  }
}

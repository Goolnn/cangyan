import 'package:flutter/material.dart';

class Capsule extends StatelessWidget {
  final String text;

  const Capsule(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const StadiumBorder(),
      color: Colors.black.withOpacity(0.15),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 4.0,
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 13.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

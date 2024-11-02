import 'package:flutter/material.dart';

class Title extends StatelessWidget {
  final String text;

  const Title(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16.0,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

import 'package:flutter/material.dart';

class Title extends StatelessWidget {
  final String text;
  final (int, int) number;

  const Title(this.text, this.number, {super.key});

  @override
  Widget build(BuildContext context) {
    String title = text;

    final startNumber = number.$1;
    final endNumber = number.$2;

    if (startNumber != 0) {
      title = '$startNumber. $title';
    }

    if (endNumber != 0) {
      title = '$title ($endNumber)';
    }

    return Expanded(
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16.0,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

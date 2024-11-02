import 'package:flutter/material.dart';

class Title extends StatelessWidget {
  final String title;

  const Title(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
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

import 'package:flutter/material.dart';

class Title extends StatelessWidget {
  final String text;
  final (int, int) number;

  final TextOverflow? overflow;
  final TextAlign? textAlign;

  const Title(
    this.text,
    this.number, {
    super.key,
    this.overflow,
    this.textAlign,
  });

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

    return Text(
      title,
      style: const TextStyle(
        fontSize: 14.0,
      ),
      overflow: overflow ?? TextOverflow.ellipsis,
      textAlign: textAlign ?? TextAlign.start,
    );
  }
}

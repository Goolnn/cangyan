import 'package:flutter/material.dart';

class EditableText extends StatefulWidget {
  final String text;

  const EditableText({
    super.key,
    required this.text,
  });

  @override
  State<EditableText> createState() => _EditableTextState();
}

class _EditableTextState extends State<EditableText> {
  late String text;

  @override
  void initState() {
    super.initState();

    text = widget.text;
  }

  @override
  Widget build(BuildContext context) {
    return Text(text);
  }
}

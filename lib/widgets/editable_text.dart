import 'package:flutter/material.dart';

class EditableText extends StatefulWidget {
  final String text;
  final void Function(String)? onSubmitted;

  const EditableText(
    this.text, {
    super.key,
    this.onSubmitted,
  });

  @override
  State<EditableText> createState() => _EditableTextState();
}

class _EditableTextState extends State<EditableText> {
  late TextEditingController _controller;

  late String _text;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();

    _text = widget.text;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        setState(() {
          _isEditing = true;

          _controller = TextEditingController(text: _text);
        });
      },
      onLongPress: () {
        setState(() {
          _isEditing = true;

          // 全选文本
          _controller = TextEditingController(text: _text);
          _controller.selection = TextSelection(
            baseOffset: 0,
            extentOffset: _controller.text.length,
          );
        });
      },
      child: _isEditing
          ? TextField(
              autofocus: true,
              controller: _controller,
              decoration: const InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
              ),
              style: Theme.of(context).textTheme.bodyMedium,
              onSubmitted: (value) {
                setState(() {
                  _text = value;
                  _isEditing = false;
                });

                if (widget.onSubmitted != null) {
                  widget.onSubmitted!(value);
                }
              },
            )
          : Text(_text),
    );
  }
}

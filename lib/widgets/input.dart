import 'dart:io';

import 'package:flutter/material.dart';

class Input extends StatefulWidget {
  final TextEditingController? controller;

  final String? placeholder;

  final void Function(String text)? onChanged;

  const Input({
    super.key,
    this.controller,
    this.placeholder,
    this.onChanged,
  });

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      controller: widget.controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        isDense: true,
        isCollapsed: true,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: Platform.isAndroid ? 6.0 : 10.0,
        ),
        hintText: widget.placeholder,
        hintStyle: const TextStyle(
          color: Colors.grey,
        ),
      ),
      style: Theme.of(context).textTheme.bodyMedium,
      onChanged: widget.onChanged,
      onTapOutside: (event) {
        focusNode.unfocus();
      },
    );
  }
}

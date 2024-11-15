import 'dart:io';

import 'package:flutter/material.dart';

class Input extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
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
        hintText: placeholder,
        hintStyle: const TextStyle(
          color: Colors.grey,
        ),
      ),
      style: Theme.of(context).textTheme.bodyMedium,
      onChanged: onChanged,
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
    );
  }
}

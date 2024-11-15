import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  final String? placeholder;

  final void Function(String text)? onChanged;

  const Input({
    super.key,
    this.placeholder,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        isDense: true,
        isCollapsed: true,
        contentPadding: const EdgeInsets.all(10.0),
        hintText: placeholder,
        hintStyle: const TextStyle(
          color: Colors.grey,
        ),
      ),
      style: Theme.of(context).textTheme.bodyMedium,
      onChanged: onChanged,
    );
  }
}

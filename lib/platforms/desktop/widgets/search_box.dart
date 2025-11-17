import 'dart:ui';

import 'package:flutter/material.dart';

class SearchBox extends StatefulWidget {
  final TextEditingController? controller;

  final Function(String text)? onChanged;

  const SearchBox({super.key, this.controller, this.onChanged});

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  final FocusNode focusNode = FocusNode();

  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();

    controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      controller.dispose();
    }

    focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,

      focusNode: focusNode,

      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(width: 1.0),
          borderRadius: BorderRadius.circular(8.0),
        ),

        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1.0, color: Colors.lightBlue),
          borderRadius: BorderRadius.circular(8.0),
        ),

        contentPadding: const EdgeInsets.symmetric(vertical: 8.0),

        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 2.0),
          child: const Icon(Icons.search, size: 16.0),
        ),

        prefixIconConstraints: const BoxConstraints(
          minWidth: 0.0,
          minHeight: 0.0,
        ),

        suffixIcon: controller.text.isNotEmpty
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    controller.clear();

                    widget.onChanged?.call('');
                  });
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 2.0, right: 8.0),
                    child: Icon(Icons.clear, size: 16.0),
                  ),
                ),
              )
            : null,

        suffixIconConstraints: const BoxConstraints(
          minWidth: 0.0,
          minHeight: 0.0,
        ),

        isCollapsed: true,
      ),

      selectionHeightStyle: BoxHeightStyle.tight,

      cursorHeight: 16.0,

      style: const TextStyle(fontSize: 14.0),

      onChanged: (value) {
        setState(() {
          widget.onChanged?.call(value);
        });
      },

      onTapOutside: (event) {
        focusNode.unfocus();
      },
    );
  }
}

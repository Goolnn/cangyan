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
    controller.dispose();

    focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
        prefixIcon: Center(child: const Icon(Icons.search, size: 16.0)),
        prefixIconConstraints: const BoxConstraints(
          maxWidth: 32.0,
          minWidth: 32.0,
        ),
        suffixIcon: controller.text.isNotEmpty
            ? Center(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      controller.clear();

                      widget.onChanged?.call('');
                    });
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Icon(Icons.clear, size: 16.0),
                  ),
                ),
              )
            : null,
        suffixIconConstraints: const BoxConstraints(
          maxWidth: 32.0,
          minWidth: 32.0,
        ),

        isCollapsed: true,
        isDense: true,
      ),
      cursorHeight: 18.0,
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

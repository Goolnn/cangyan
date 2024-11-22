import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:cangyan/cangyan.dart' as cangyan;

class DuplicatedPage extends StatefulWidget {
  final cangyan.Workspace workspace;

  final List<(String, Uint8List)> pairs;

  const DuplicatedPage({
    super.key,
    required this.workspace,
    required this.pairs,
  });

  @override
  State<DuplicatedPage> createState() => _DuplicatedPageState();
}

class _DuplicatedPageState extends State<DuplicatedPage> {
  late List<(String, Uint8List)> pairs;

  @override
  void initState() {
    super.initState();

    pairs = widget.pairs;
  }

  @override
  Widget build(BuildContext context) {
    final duplicateds = pairs.map(
      (title) {
        return !widget.workspace.check(title: title.$1);
      },
    ).toList();

    return AlertDialog(
      title: const Text('工程重名'),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 8.0,
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 128.0,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < pairs.length; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (pairs.length == 1) {
                            Navigator.of(context).pop(null);
                          } else {
                            setState(() {
                              pairs.removeAt(i);
                            });
                          }
                        },
                        child: const Icon(
                          Icons.close,
                          size: 20.0,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: cangyan.EditableText(
                          pairs[i].$1,
                          onSubmitted: (text) {
                            setState(() {
                              pairs[i] = (text, pairs[i].$2);
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Icon(
                        duplicateds[i]
                            ? Icons.error_outline
                            : Icons.check_circle_outline,
                        color: duplicateds[i] ? Colors.red : Colors.green,
                      ),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(null);
          },
          child: const Text('取消'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(pairs);
          },
          child: const Text('导入'),
        ),
      ],
    );
  }
}

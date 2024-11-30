import 'dart:typed_data';

import 'package:cangyan/dialogs/standard_dialog.dart';
import 'package:flutter/material.dart';
import 'package:cangyan/cangyan.dart' as cangyan;

class DuplicatedNameDialog extends StatefulWidget {
  final cangyan.Workspace workspace;

  final List<(String, Uint8List)> pairs;

  const DuplicatedNameDialog({
    super.key,
    required this.workspace,
    required this.pairs,
  });

  @override
  State<DuplicatedNameDialog> createState() => _DuplicatedNameDialogState();
}

class _DuplicatedNameDialogState extends State<DuplicatedNameDialog> {
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

    return StandardDialog(
      title: '工程重名',
      action: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FilledButton.tonal(
            onPressed: () {
              Navigator.of(context).maybePop(null);
            },
            child: const Text('取消'),
          ),
          const SizedBox.square(dimension: 8.0),
          FilledButton(
            onPressed: () {
              Navigator.of(context).maybePop(pairs);
            },
            child: const Text('导入'),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ConstrainedBox(
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
                            Icon(
                              duplicateds[i]
                                  ? Icons.error_outline
                                  : Icons.check_circle_outline,
                              color: duplicateds[i] ? Colors.red : Colors.green,
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
                            GestureDetector(
                              onTap: () {
                                if (pairs.length == 1) {
                                  Navigator.of(context).maybePop(null);
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
                          ],
                        ),
                      )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cangyan/cangyan.dart' as cangyan;

class DuplicatedPage extends StatefulWidget {
  final cangyan.Workspace workspace;

  final String title;

  const DuplicatedPage({
    super.key,
    required this.workspace,
    required this.title,
  });

  @override
  State<DuplicatedPage> createState() => _DuplicatedPageState();
}

class _DuplicatedPageState extends State<DuplicatedPage> {
  late String title;

  @override
  void initState() {
    super.initState();

    title = widget.title;
  }

  @override
  Widget build(BuildContext context) {
    final duplicated = !widget.workspace.check(title: title);

    return AlertDialog(
      title: const Text('工程已存在'),
      content: Row(
        children: [
          Expanded(
            child: cangyan.EditableText(
              title,
              onSubmitted: (text) {
                setState(() {
                  title = text;
                });
              },
            ),
          ),
          Icon(
            duplicated ? Icons.error_outline : Icons.check_circle_outline,
            color: duplicated ? Colors.red : Colors.green,
          ),
        ],
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
            Navigator.of(context).pop(title);
          },
          child: Text(duplicated ? '覆盖' : '导入'),
        ),
      ],
    );
  }
}

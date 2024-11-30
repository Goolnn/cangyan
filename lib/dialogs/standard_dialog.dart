import 'package:flutter/material.dart';

class StandardDialog extends StatelessWidget {
  final String title;
  final Widget action;
  final Widget child;

  const StandardDialog({
    super.key,
    required this.title,
    required this.action,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
            const Divider(),
            child,
            const Divider(),
            action,
          ],
        ),
      ),
    );
  }
}

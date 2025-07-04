import 'dart:io';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

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
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 800.0,
          maxHeight: 600.0,
        ),
        child: Builder(builder: (context) {
          final double aspectRatio;

          switch (Platform.operatingSystem) {
            case 'android':
              aspectRatio =
                  MediaQuery.of(context).orientation == Orientation.portrait
                      ? 3.0 / 5.0
                      : 4.0 / 3.0;
              break;
            default:
              aspectRatio = 4.0 / 3.0;
          }

          return AspectRatio(
            aspectRatio: aspectRatio,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      Positioned.fill(
                        child: DragToMoveArea(
                          child: Container(),
                        ),
                      ),
                      Center(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  child,
                  const Divider(),
                  action,
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

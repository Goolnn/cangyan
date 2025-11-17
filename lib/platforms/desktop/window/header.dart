import 'dart:io';

import 'package:cangyan/platforms/desktop/window/button.dart' as window;
import 'package:cangyan/platforms/desktop/window/frame.dart' as window;
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class Header extends StatefulWidget {
  final List<Widget>? buttons;

  final Widget? panel;

  const Header({super.key, this.buttons, this.panel});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (Platform.isWindows)
          DragToMoveArea(
            child: SizedBox(
              width: double.infinity,
              height: window.kWindowTitleBarSize,
            ),
          ),

        if (widget.panel != null)
          SizedBox(
            width: double.infinity,
            height: window.kWindowTitleBarSize,
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 100),

              child: widget.panel!,
            ),
          ),

        Row(
          children: [
            if (widget.buttons != null) ...widget.buttons!,

            Spacer(),

            if (Platform.isWindows) ...[
              window.WindowMinimizeButton(),
              window.WindowMaximizeAndRestoreButton(),
              window.WindowCloseButton(),
            ],
          ],
        ),
      ],
    );
  }
}

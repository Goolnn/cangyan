import 'dart:io';

import 'package:cangyan/platforms/desktop/window/button.dart' as window;
import 'package:cangyan/platforms/desktop/window/frame.dart' as window;
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:window_manager/window_manager.dart';

class Header extends StatefulWidget {
  final List<window.Button>? buttons;

  final Widget? panel;

  const Header({super.key, this.buttons, this.panel});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> with WindowListener {
  bool _isMaximized = false;

  @override
  void initState() {
    super.initState();

    windowManager.addListener(this);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);

    super.dispose();
  }

  @override
  void onWindowMaximize() {
    super.onWindowMaximize();

    setState(() {
      _isMaximized = true;
    });
  }

  @override
  void onWindowUnmaximize() {
    super.onWindowUnmaximize();

    setState(() {
      _isMaximized = false;
    });
  }

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
            child: widget.panel!,
          ),

        Row(
          children: [
            if (widget.buttons != null) ...widget.buttons!,

            Spacer(),

            if (Platform.isWindows) ...[
              window.Button(
                onPressed: () async {
                  await windowManager.minimize();
                },

                child: Icon(
                  MdiIcons.windowMinimize,
                  size: window.kWindowTitleBarSize * 0.4,
                ),
              ),

              window.Button(
                onPressed: () async {
                  if (_isMaximized) {
                    await windowManager.unmaximize();
                  } else {
                    await windowManager.maximize();
                  }
                },

                child: Icon(
                  _isMaximized
                      ? MdiIcons.windowRestore
                      : MdiIcons.windowMaximize,
                  size: window.kWindowTitleBarSize * 0.4,
                ),
              ),

              window.Button(
                onPressed: () async {
                  await windowManager.close();
                },

                hoverColor: Colors.red.withAlpha((0.65 * 255).toInt()),

                child: Icon(
                  MdiIcons.closeThick,
                  size: window.kWindowTitleBarSize * 0.4,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

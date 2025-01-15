import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:window_manager/window_manager.dart';

class Page extends StatefulWidget {
  final Widget? headerButtons;

  final Widget child;

  const Page({
    super.key,
    this.headerButtons,
    required this.child,
  });

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> with WindowListener {
  final double headerSize = 36.0;

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

    setState(() {});
  }

  @override
  void onWindowUnmaximize() {
    super.onWindowUnmaximize();

    setState(() {});
  }

  @override
  void onWindowFocus() {
    super.onWindowFocus();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: headerSize,
            child: Stack(
              children: [
                DragToMoveArea(
                  child: SizedBox(
                    width: double.infinity,
                    height: headerSize,
                  ),
                ),
                Row(
                  children: [
                    HeaderButton(
                      onPressed: () {},
                      child: Icon(
                        Icons.menu,
                        size: headerSize * 0.5,
                      ),
                    ),
                    const Spacer(),
                    HeaderButton(
                      onPressed: windowManager.minimize,
                      child: Icon(
                        MaterialCommunityIcons.window_minimize,
                        size: headerSize * 0.4,
                      ),
                    ),
                    FutureBuilder(
                      future: windowManager.isMaximized(),
                      builder: (context, snapshot) {
                        final isMaximized = snapshot.data;

                        return HeaderButton(
                          onPressed: () {
                            if (isMaximized == true) {
                              windowManager.unmaximize();
                            } else {
                              windowManager.maximize();
                            }
                          },
                          child: Icon(
                            isMaximized == true
                                ? MaterialCommunityIcons.window_restore
                                : MaterialCommunityIcons.window_maximize,
                            size: headerSize * 0.4,
                          ),
                        );
                      },
                    ),
                    HeaderButton(
                      isDangerous: true,
                      onPressed: windowManager.close,
                      child: Icon(
                        MaterialCommunityIcons.window_close,
                        size: headerSize * 0.4,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Flexible(
            child: widget.child,
          ),
        ],
      ),
    );
  }
}

class HeaderButton extends StatelessWidget {
  final bool isDangerous;

  final void Function()? onPressed;

  final Widget child;

  const HeaderButton({
    super.key,
    this.isDangerous = false,
    this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return RawMaterialButton(
          constraints: BoxConstraints.tightFor(
            width: constraints.maxHeight,
            height: constraints.maxHeight,
          ),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          hoverColor: isDangerous ? Colors.red.shade300 : null,
          onPressed: onPressed,
          child: child,
        );
      },
    );
  }
}

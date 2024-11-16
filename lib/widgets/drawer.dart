import 'dart:math';

import 'package:flutter/material.dart';

class Drawer extends StatefulWidget {
  final DrawerController? controller;

  final Widget child;
  final Widget? board;

  const Drawer({
    super.key,
    this.controller,
    required this.child,
    this.board,
  });

  @override
  State<Drawer> createState() => _DrawerState();
}

class _DrawerState extends State<Drawer> {
  final key = GlobalKey();

  Curve curve = Curves.easeOutCubic;
  bool show = false;

  Size? size;

  double? dragging;

  @override
  void initState() {
    super.initState();

    if (widget.controller != null) {
      widget.controller!.addListener(() {
        setState(() {
          show = widget.controller!.open;

          if (show) {
            curve = Curves.easeOutCubic;
          } else {
            curve = Curves.easeInCubic;
          }
        });
      });
    }

    updateSize();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !show,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }

        setState(() {
          show = false;

          curve = Curves.easeInCubic;
        });
      },
      child: NotificationListener<SizeChangedLayoutNotification>(
        onNotification: (notification) {
          updateSize();

          return true;
        },
        child: SizeChangedLayoutNotifier(
          child: Stack(
            key: key,
            children: [
              widget.child,
              if (size != null)
                AnimatedPositioned(
                  curve: curve,
                  duration: dragging != null
                      ? const Duration()
                      : const Duration(milliseconds: 300),
                  bottom: show
                      ? (dragging != null ? min(0.0, -dragging!) : 0.0)
                      : -size!.height,
                  child: SizedBox(
                    width: size!.width,
                    height: size!.height,
                    child: Card(
                      elevation: 8.0,
                      child: Column(
                        children: [
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onPanStart: (details) {
                              setState(() {
                                dragging = 0.0;
                              });
                            },
                            onPanUpdate: (details) {
                              setState(() {
                                dragging = details.localPosition.dy;
                              });
                            },
                            onPanEnd: (details) {
                              final v = details.velocity.pixelsPerSecond.dy;
                              final l = size!.height / 2.0;

                              if (v >= 1000.0 || dragging! >= l) {
                                setState(() {
                                  show = false;

                                  curve = Curves.easeOutCubic;
                                });
                              }

                              setState(() {
                                dragging = null;
                              });
                            },
                            child: const Center(
                              child: FractionallySizedBox(
                                widthFactor: 0.2,
                                child: Divider(
                                  thickness: 1.5,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: widget.board ?? Container(),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  void updateSize() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final renderBox = key.currentContext!.findRenderObject() as RenderBox;

      final size = Size(
        renderBox.size.width,
        renderBox.size.height / 3.0,
      );

      if (this.size == size) {
        return;
      }

      setState(() {
        this.size = size;
      });
    });
  }
}

class DrawerController extends ChangeNotifier {
  bool open;

  DrawerController({
    this.open = false,
  });

  void show() {
    open = true;

    notifyListeners();
  }

  void hide() {
    open = false;

    notifyListeners();
  }
}

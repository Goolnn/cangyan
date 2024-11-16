import 'dart:math';

import 'package:flutter/material.dart';

class NotePad extends StatefulWidget {
  final Widget child;

  const NotePad({
    super.key,
    required this.child,
  });

  @override
  State<NotePad> createState() => _NotePadState();
}

class _NotePadState extends State<NotePad> {
  final key = GlobalKey();

  bool show = true;

  Size? size;

  double? dragging;

  @override
  void initState() {
    super.initState();

    updateSize();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<SizeChangedLayoutNotification>(
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
                curve: show ? Curves.easeInQuad : Curves.easeOutQuad,
                duration: dragging != null
                    ? const Duration()
                    : const Duration(milliseconds: 350),
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

                            final line = size!.height / 2.0;

                            if (v >= 1000.0 || dragging! >= line) {
                              setState(() {
                                show = false;
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
                      ],
                    ),
                  ),
                ),
              )
          ],
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

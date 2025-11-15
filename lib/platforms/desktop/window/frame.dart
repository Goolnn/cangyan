import 'dart:ui';

import 'package:cangyan/platforms/desktop/window/body.dart' as window;
import 'package:cangyan/platforms/desktop/window/header.dart' as window;
import 'package:cangyan/platforms/desktop/window/page.dart' as window;
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const double kWindowTitleBarSize = 36.0;

class Frame extends StatefulWidget {
  final Widget child;

  const Frame({super.key, required this.child});

  @override
  State<Frame> createState() => _FrameState();
}

class _FrameState extends State<Frame> with SingleTickerProviderStateMixin {
  late RouteObserver<PageRoute> _observer;

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _observer = RouteObserver<PageRoute>();

    _controller = AnimationController(
      duration: Duration(milliseconds: 250),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => window.PageModel(),

      child: Stack(
        children: [
          Consumer<window.PageModel>(
            builder: (context, value, child) {
              return DropTarget(
                enable: value.droppable,

                onDragDone: (details) {
                  // TODO: handle file drop
                },

                onDragEntered: (details) {
                  _controller.forward();
                },

                onDragExited: (details) {
                  _controller.reverse();
                },

                child: SizedBox.expand(),
              );
            },
          ),

          Column(
            children: [
              Consumer<window.PageModel>(
                builder: (context, value, child) {
                  return window.Header(
                    buttons: value.buttons,
                    panel: value.panel,
                  );
                },
              ),

              Flexible(
                child: ObserverData(
                  observer: _observer,
                  child: window.Body(observer: _observer, child: widget.child),
                ),
              ),
            ],
          ),

          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return IgnorePointer(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 4.0 * _animation.value,
                    sigmaY: 4.0 * _animation.value,
                  ),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.black.withAlpha(
                      (255.0 * 0.25 * _animation.value).toInt(),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.file_upload_outlined,
                        size: 96.0,
                        color: Colors.white.withAlpha(
                          (255.0 * _animation.value).toInt(),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ObserverData extends InheritedWidget {
  final RouteObserver<PageRoute> observer;

  const ObserverData({super.key, required this.observer, required super.child});

  static ObserverData? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ObserverData>();
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}

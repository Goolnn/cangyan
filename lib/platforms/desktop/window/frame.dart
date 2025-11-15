import 'package:cangyan/platforms/desktop/window/body.dart' as window;
import 'package:cangyan/platforms/desktop/window/header.dart' as window;
import 'package:cangyan/platforms/desktop/window/page.dart' as window;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const double kWindowTitleBarSize = 36.0;

class Frame extends StatefulWidget {
  final Widget child;

  const Frame({super.key, required this.child});

  @override
  State<Frame> createState() => _FrameState();
}

class _FrameState extends State<Frame> {
  late RouteObserver<PageRoute> _observer;

  @override
  void initState() {
    super.initState();

    _observer = RouteObserver<PageRoute>();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => window.PageModel(),

      child: Column(
        children: [
          Consumer<window.PageModel>(
            builder: (context, value, child) {
              return window.Header(buttons: value.buttons, panel: value.panel);
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

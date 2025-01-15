import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:window_manager/window_manager.dart';

final observer = RouteObserver<PageRoute>();
final broadcast = StreamController<(List<HeaderButton>?, Widget?)>.broadcast();

class Frame extends StatefulWidget {
  final Widget child;

  const Frame({
    super.key,
    required this.child,
  });

  @override
  State<Frame> createState() => _FrameState();
}

class _FrameState extends State<Frame> with WindowListener {
  late final StreamSubscription<(List<HeaderButton>?, Widget?)> subscription;

  final double headerSize = 36.0;

  List<HeaderButton>? buttons;
  Widget? header;

  @override
  void initState() {
    super.initState();

    subscription = broadcast.stream.listen((widgets) {
      final buttons = widgets.$1;
      final header = widgets.$2;

      setState(() {
        this.buttons = buttons;
        this.header = header;
      });
    });

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
      body: SafeArea(
        child: Column(
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
                      if (buttons != null)
                        for (final button in buttons!) button,
                      const Spacer(),
                      if (Platform.isWindows) ...[
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
                    ],
                  ),
                  if (header != null) header!,
                ],
              ),
            ),
            Flexible(
              child: Navigator(
                onGenerateRoute: (settings) {
                  return MaterialPageRoute(
                    builder: (context) => widget.child,
                    settings: settings,
                  );
                },
                observers: [
                  observer,
                ],
              ),
            ),
          ],
        ),
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

class Page extends StatefulWidget {
  final List<HeaderButton>? buttons;
  final Widget? header;
  final Widget child;

  const Page({
    super.key,
    this.buttons,
    this.header,
    required this.child,
  });

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    observer.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void dispose() {
    observer.unsubscribe(this);

    super.dispose();
  }

  @override
  void didPush() {
    super.didPush();

    broadcast.sink.add((widget.buttons, widget.header));
  }

  @override
  void didPopNext() {
    super.didPopNext();

    broadcast.sink.add((widget.buttons, widget.header));
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

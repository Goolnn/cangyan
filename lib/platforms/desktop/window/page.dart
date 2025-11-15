import 'package:cangyan/platforms/desktop/window/button.dart' as window;
import 'package:cangyan/platforms/desktop/window/frame.dart' as window;
import 'package:cangyan/platforms/desktop/window/page.dart' as window;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Page extends StatefulWidget {
  final bool droppable;

  final List<window.Button>? buttons;
  final Widget? panel;

  final Widget child;

  const Page({
    super.key,

    this.droppable = false,

    this.buttons,
    this.panel,

    required this.child,
  });

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> with RouteAware {
  RouteObserver<PageRoute>? _observer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _observer = window.ObserverData.of(context)?.observer;

    _observer?.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void dispose() {
    _observer?.unsubscribe(this);

    super.dispose();
  }

  @override
  void didPush() {
    super.didPush();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<window.PageModel>().updateFrame(
        widget.droppable,

        widget.buttons,
        widget.panel,
      );
    });
  }

  @override
  void didPopNext() {
    super.didPopNext();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<window.PageModel>().updateFrame(
        widget.droppable,

        widget.buttons,
        widget.panel,
      );
    });
  }

  @override
  void didUpdateWidget(covariant Page oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (ModalRoute.of(context)?.isCurrent ?? false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<window.PageModel>().updateFrame(
          widget.droppable,

          widget.buttons,
          widget.panel,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class PageModel extends ChangeNotifier {
  bool _droppable = false;

  List<window.Button>? _buttons;
  Widget? _panel;

  bool get droppable => _droppable;

  List<window.Button>? get buttons => _buttons;
  Widget? get panel => _panel;

  void updateFrame(
    bool draggable,

    List<window.Button>? buttons,
    Widget? panel,
  ) {
    _droppable = draggable;

    _buttons = buttons;
    _panel = panel;

    notifyListeners();
  }
}

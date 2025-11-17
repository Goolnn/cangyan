import 'package:cangyan/platforms/desktop/window/frame.dart' as window;
import 'package:cangyan/platforms/desktop/window/page.dart' as window;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Page extends StatefulWidget {
  final Widget? dropping;
  final List<Widget>? buttons;
  final Widget? panel;

  final Widget child;

  const Page({
    super.key,

    this.dropping,
    this.buttons,
    this.panel,

    required this.child,
  });

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> with RouteAware {
  final Key _pageKey = UniqueKey();

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
        _pageKey,

        widget.dropping,
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
        _pageKey,

        widget.dropping,
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
          _pageKey,

          widget.dropping,
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
  Key? _pageKey;

  Widget? _dropping;
  List<Widget>? _buttons;
  Widget? _panel;

  Key? get pageKey => _pageKey;

  Widget? get dropping => _dropping;
  List<Widget>? get buttons => _buttons;
  Widget? get panel => _panel;

  void updateFrame(
    Key? pageKey,

    Widget? dropping,
    List<Widget>? buttons,
    Widget? panel,
  ) {
    _pageKey = pageKey;

    _dropping = dropping;
    _buttons = buttons;
    _panel = panel;

    notifyListeners();
  }
}

import 'package:cangyan/l10n/app_localizations.dart';
import 'package:cangyan/platforms/desktop/window/frame.dart' as window;
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:window_manager/window_manager.dart';

class WindowButton extends StatelessWidget {
  final EdgeInsetsGeometry? margin;

  final Color? fillColor;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? splashColor;
  final Color? highlightColor;

  final void Function()? onPressed;

  final Widget child;

  const WindowButton({
    super.key,

    this.margin = const EdgeInsets.all(2.0),

    this.fillColor,
    this.focusColor,
    this.hoverColor,
    this.splashColor,
    this.highlightColor,

    this.onPressed,

    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,

      child: RawMaterialButton(
        constraints: BoxConstraints.tightFor(
          width: window.kWindowTitleBarSize - (margin?.horizontal ?? 0.0),
          height: window.kWindowTitleBarSize - (margin?.vertical ?? 0.0),
        ),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),

        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,

        fillColor: fillColor,
        focusColor: focusColor,
        hoverColor: hoverColor,
        splashColor: splashColor,
        highlightColor: highlightColor,

        onPressed: onPressed,

        child: child,
      ),
    );
  }
}

class WindowMinimizeButton extends StatelessWidget {
  const WindowMinimizeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: AppLocalizations.of(context)!.windowMinimize,

      waitDuration: Duration(milliseconds: 500),

      child: WindowButton(
        onPressed: () async {
          await windowManager.minimize();
        },

        child: Icon(
          MdiIcons.windowMinimize,
          size: window.kWindowTitleBarSize * 0.4,
        ),
      ),
    );
  }
}

class WindowMaximizeAndRestoreButton extends StatefulWidget {
  const WindowMaximizeAndRestoreButton({super.key});

  @override
  State<WindowMaximizeAndRestoreButton> createState() =>
      _WindowMaximizeAndRestoreButtonState();
}

class _WindowMaximizeAndRestoreButtonState
    extends State<WindowMaximizeAndRestoreButton>
    with WindowListener {
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
    return Tooltip(
      message: _isMaximized
          ? AppLocalizations.of(context)!.windowRestore
          : AppLocalizations.of(context)!.windowMaximize,

      waitDuration: Duration(milliseconds: 500),

      child: WindowButton(
        onPressed: () async {
          if (_isMaximized) {
            await windowManager.unmaximize();
          } else {
            await windowManager.maximize();
          }
        },

        child: Icon(
          _isMaximized ? MdiIcons.windowRestore : MdiIcons.windowMaximize,
          size: window.kWindowTitleBarSize * 0.4,
        ),
      ),
    );
  }
}

class WindowCloseButton extends StatelessWidget {
  const WindowCloseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: AppLocalizations.of(context)!.windowClose,

      waitDuration: Duration(milliseconds: 500),

      child: WindowButton(
        onPressed: () async {
          await windowManager.close();
        },

        hoverColor: Colors.red.withAlpha((0.65 * 255).toInt()),

        child: Icon(
          MdiIcons.closeThick,
          size: window.kWindowTitleBarSize * 0.4,
        ),
      ),
    );
  }
}

class WindowBackButton extends StatelessWidget {
  final BuildContext context;

  const WindowBackButton(this.context, {super.key});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: AppLocalizations.of(context)!.windowBack,

      waitDuration: Duration(milliseconds: 500),

      child: WindowButton(
        onPressed: () {
          Navigator.of(this.context).maybePop();
        },
        child: Icon(Icons.arrow_back, size: 16.0),
      ),
    );
  }
}

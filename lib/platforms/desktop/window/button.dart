import 'package:cangyan/platforms/desktop/window/frame.dart' as window;
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Color? fillColor;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? splashColor;
  final Color? highlightColor;

  final void Function()? onPressed;

  final Widget child;

  const Button({
    super.key,
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
    return RawMaterialButton(
      constraints: BoxConstraints.tightFor(
        width: window.kWindowTitleBarHeight * 1.1,
        height: window.kWindowTitleBarHeight,
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      fillColor: fillColor,
      focusColor: focusColor,
      hoverColor: hoverColor,
      splashColor: splashColor,
      highlightColor: highlightColor,
      onPressed: onPressed,
      child: child,
    );
  }
}

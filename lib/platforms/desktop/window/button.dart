import 'package:cangyan/platforms/desktop/window/frame.dart' as window;
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final EdgeInsetsGeometry? margin;

  final Color? fillColor;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? splashColor;
  final Color? highlightColor;

  final void Function()? onPressed;

  final Widget child;

  const Button({
    super.key,

    this.margin = const .all(2.0),

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
      padding: margin ?? .zero,

      child: RawMaterialButton(
        constraints: .tightFor(
          width: window.kWindowTitleBarSize - (margin?.horizontal ?? 0.0),
          height: window.kWindowTitleBarSize - (margin?.vertical ?? 0.0),
        ),

        shape: RoundedRectangleBorder(borderRadius: .all(Radius.circular(8.0))),

        materialTapTargetSize: .shrinkWrap,

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

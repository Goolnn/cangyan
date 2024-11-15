import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final ButtonType type;
  final Function()? onPressed;

  const Button(
    this.text, {
    super.key,
    this.type = ButtonType.standard,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color foregroundColor;
    Color borderColor;
    double borderSize;

    switch (type) {
      case ButtonType.primary:
        backgroundColor = Colors.blue;
        foregroundColor = Colors.white;
        borderColor = Colors.blue;
        borderSize = 0.0;
        break;
      case ButtonType.standard:
        backgroundColor = Colors.white;
        foregroundColor = Colors.black;
        borderColor = Colors.grey;
        borderSize = 1.0;
        break;
    }

    if (onPressed == null) {
      backgroundColor = Colors.grey.shade400;
      borderColor = Colors.grey.shade400;
      foregroundColor = Colors.white;
    }

    return RawMaterialButton(
      elevation: 0.0,
      focusElevation: 0.0,
      hoverElevation: 0.0,
      disabledElevation: 0.0,
      highlightElevation: 0.0,
      constraints: const BoxConstraints(
        minWidth: 72.0,
        minHeight: 32.0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(
          color: borderColor,
          width: borderSize,
        ),
      ),
      fillColor: backgroundColor,
      textStyle: TextStyle(
        color: foregroundColor,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onPressed: onPressed,
      child: Text(text),
    );
  }
}

enum ButtonType {
  primary,
  standard,
}

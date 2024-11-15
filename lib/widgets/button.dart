import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;

  const Button(
    this.text, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
        side: const BorderSide(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      fillColor: Colors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onPressed: () {},
      child: Text(text),
    );
  }
}

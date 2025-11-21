import 'package:flutter/material.dart';

class Note extends StatelessWidget {
  final void Function()? onPressed;

  final int index;

  const Note({super.key, this.onPressed, required this.index});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      constraints: BoxConstraints.tightFor(width: 32.0, height: 32.0),

      shape: OvalBorder(),

      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,

      fillColor: Colors.red,
      splashColor: Colors.transparent,

      elevation: 0.0,
      focusElevation: 0.0,
      hoverElevation: 0.0,
      disabledElevation: 0.0,
      highlightElevation: 0.0,

      onPressed: onPressed,

      child: Text(index.toString(), style: TextStyle(color: Colors.white)),
    );
  }
}

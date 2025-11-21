import 'package:flutter/material.dart';

class Note extends StatelessWidget {
  final int index;

  const Note({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      constraints: BoxConstraints.tightFor(width: 32.0, height: 32.0),

      shape: OvalBorder(),

      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,

      fillColor: Colors.red,
      splashColor: Colors.transparent,

      onPressed: () {},

      child: Text(index.toString(), style: TextStyle(color: Colors.white)),
    );
  }
}

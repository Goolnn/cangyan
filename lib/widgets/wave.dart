import 'package:flutter/material.dart';

class Wave extends StatelessWidget {
  final Widget child;

  final Function()? onPress;
  final Function()? onLongPress;

  const Wave({
    super.key,
    required this.child,
    this.onPress,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: Colors.black.withOpacity(0.08),
              highlightColor: Colors.black.withOpacity(0.08),
              onTap: onPress,
              onLongPress: onLongPress,
            ),
          ),
        ),
      ],
    );
  }
}

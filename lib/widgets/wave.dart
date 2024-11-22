import 'package:flutter/material.dart';

class Wave extends StatelessWidget {
  final BorderRadius? borderRadius;

  final Function()? onTap;
  final Function()? onLongPress;
  final Function(LongPressStartDetails details)? onLongPressStart;
  final Function(LongPressEndDetails details)? onLongPressEnd;

  final Widget child;

  const Wave({
    super.key,
    this.borderRadius,
    this.onTap,
    this.onLongPress,
    this.onLongPressStart,
    this.onLongPressEnd,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      onLongPressStart: onLongPressStart,
      onLongPressEnd: onLongPressEnd,
      child: Stack(
        children: [
          child,
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: borderRadius,
                splashColor: Colors.black.withOpacity(0.08),
                highlightColor: Colors.black.withOpacity(0.08),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

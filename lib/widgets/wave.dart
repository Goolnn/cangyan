import 'package:flutter/material.dart';

class Wave extends StatelessWidget {
  final BorderRadius? borderRadius;

  final Function()? onPress;
  final Function()? onLongPress;

  final Widget child;

  const Wave({
    super.key,
    this.borderRadius,
    this.onPress,
    this.onLongPress,
    required this.child,
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
              borderRadius: borderRadius,
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

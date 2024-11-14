import 'package:flutter/material.dart';

class Mark extends StatelessWidget {
  static const duration = Duration(milliseconds: 300);

  final int index;
  final bool isDone;
  final double size;
  final void Function()? onPressed;
  final void Function()? onLongPressed;

  const Mark({
    super.key,
    required this.index,
    this.size = 16.0,
    this.isDone = false,
    this.onPressed,
    this.onLongPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPressed,
      child: SizedBox.fromSize(
        size: Size.fromRadius(size),
        child: TweenAnimationBuilder(
          duration: duration,
          tween: ColorTween(
            begin: Colors.red,
            end: isDone ? Colors.lightBlue : Colors.red,
          ),
          builder: (context, value, child) {
            return FilledButton(
              style: ButtonStyle(
                elevation: const WidgetStatePropertyAll(8.0),
                shape: const WidgetStatePropertyAll(CircleBorder()),
                backgroundColor: WidgetStatePropertyAll(value),
                padding: const WidgetStatePropertyAll(EdgeInsets.zero),
              ),
              onPressed: onPressed,
              child: AnimatedSwitcher(
                duration: duration,
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                child: isDone
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16.0,
                      )
                    : Text(
                        '$index',
                        style: const TextStyle(color: Colors.white),
                      ),
              ),
            );
          },
        ),
      ),
    );
  }
}

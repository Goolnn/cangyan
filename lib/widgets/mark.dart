import 'package:flutter/material.dart';

class Mark extends StatelessWidget {
  static const duration = Duration(milliseconds: 300);
  static const size = 16.0;

  final int index;
  final bool isDone;
  final void Function()? onPressed;

  const Mark({
    super.key,
    required this.index,
    this.isDone = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(-size, -size),
      child: SizedBox.fromSize(
        size: const Size.fromRadius(size),
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

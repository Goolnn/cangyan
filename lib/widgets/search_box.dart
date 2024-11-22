import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class SearchBox extends StatefulWidget {
  final TextEditingController? controller;

  final Function(String text)? onChanged;

  const SearchBox({
    super.key,
    this.controller,
    this.onChanged,
  });

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox>
    with SingleTickerProviderStateMixin {
  final FocusNode focusNode = FocusNode();

  late final TextEditingController controller;

  late AnimationController animationController;

  late Animation<Color?> colorAnimation;
  late Animation<double> widthAnimation;

  @override
  void initState() {
    super.initState();

    controller = widget.controller ?? TextEditingController();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    colorAnimation = ColorTween(
      begin: Colors.blueGrey,
      end: Colors.blue,
    ).animate(animationController);

    widthAnimation = Tween<double>(
      begin: 1.0,
      end: 1.5,
    ).animate(animationController);

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        animationController.forward();
      } else {
        animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();

    focusNode.dispose();

    animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) {
          if (!isKeyboardVisible) {
            focusNode.unfocus();
          }

          return AnimatedBuilder(
            animation: colorAnimation,
            builder: (context, child) {
              return TextField(
                controller: controller,
                focusNode: focusNode,
                decoration: InputDecoration(
                  border: StadiumInputBorder(
                    color: colorAnimation.value,
                    width: widthAnimation.value,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 4.0,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 32.0,
                  ),
                  suffixIcon: controller.text.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              controller.clear();
                            });

                            widget.onChanged?.call('');
                          },
                          child: const Icon(Icons.clear),
                        )
                      : null,
                  suffixIconConstraints: const BoxConstraints(
                    minWidth: 32.0,
                  ),
                  isCollapsed: true,
                  isDense: true,
                ),
                style: const TextStyle(
                  fontSize: 14.0,
                ),
                onChanged: widget.onChanged,
              );
            },
          );
        },
      ),
    );
  }
}

class StadiumInputBorder extends InputBorder {
  final Color? color;
  final double? width;

  const StadiumInputBorder({
    this.color,
    this.width,
  });

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(1.0);

  @override
  bool get isOutline => true;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    final RRect rrect = RRect.fromRectAndRadius(
      rect.deflate(borderSide.width),
      Radius.circular(rect.height / 2.0),
    );

    return Path()..addRRect(rrect);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final RRect rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(rect.height / 2.0),
    );

    return Path()..addRRect(rrect);
  }

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    double? gapStart,
    double gapExtent = 0.0,
    double gapPercentage = 0.0,
    TextDirection? textDirection,
  }) {
    final Paint paint = Paint()
      ..color = color ?? Colors.blueGrey
      ..style = PaintingStyle.stroke
      ..strokeWidth = width ?? 1.0;

    final Path path = getOuterPath(rect);

    canvas.drawPath(path, paint);
  }

  @override
  InputBorder copyWith({BorderSide? borderSide}) {
    return this;
  }

  @override
  ShapeBorder scale(double t) {
    return this;
  }
}

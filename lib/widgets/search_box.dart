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
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: colorAnimation.value!,
                        width: widthAnimation.value,
                      )),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 8.0,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 32.0,
                  ),
                  isCollapsed: true,
                  isDense: true,
                ),
                cursorHeight: 18.0,
                style: const TextStyle(
                  fontSize: 14.0,
                ),
                onChanged: widget.onChanged,
                onTapOutside: (event) {
                  focusNode.unfocus();
                },
              );
            },
          );
        },
      ),
    );
  }
}

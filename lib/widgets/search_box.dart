import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  final TextEditingController? controller;

  final Function(String text)? onChanged;

  const SearchBox({
    super.key,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextField(
        controller: controller,
        decoration: const InputDecoration(
          border: StadiumInputBorder(),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 4.0,
          ),
          prefixIcon: Icon(Icons.search),
          prefixIconConstraints: BoxConstraints(
            minWidth: 32.0,
          ),
          isCollapsed: true,
          isDense: true,
        ),
        style: const TextStyle(
          fontSize: 14.0,
        ),
        onTapOutside: (event) {
          FocusScope.of(context).unfocus();
        },
        onChanged: onChanged,
      ),
    );
  }
}

class StadiumInputBorder extends InputBorder {
  const StadiumInputBorder({
    super.borderSide = const BorderSide(),
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
      ..color = Colors.blueGrey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final Path path = getOuterPath(rect);

    canvas.drawPath(path, paint);
  }

  @override
  InputBorder copyWith({BorderSide? borderSide}) {
    return StadiumInputBorder(
      borderSide: borderSide ?? this.borderSide,
    );
  }

  @override
  ShapeBorder scale(double t) {
    return StadiumInputBorder(
      borderSide: borderSide.scale(t),
    );
  }
}

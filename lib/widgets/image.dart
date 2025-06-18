import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as flutter;

class Image extends StatelessWidget {
  final double borderRadius = 8.0;

  final ImageProvider? provider;

  const Image({super.key, this.provider});

  @override
  Widget build(BuildContext context) {
    return provider != null
        ? Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: flutter.Image(
                image: provider!,
              ),
            ),
          )
        : Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              color: Colors.grey.withValues(alpha: 0.25),
            ),
            child: const Icon(Icons.image_not_supported),
          );
  }
}

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as flutter;

class Image extends StatelessWidget {
  final double borderRadius = 8.0;

  final Uint8List? image;

  const Image({super.key, this.image});

  @override
  Widget build(BuildContext context) {
    return image != null
        ? Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: flutter.Image(
                image: MemoryImage(image!),
              ),
            ),
          )
        : Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              color: Colors.grey.withOpacity(0.25),
            ),
            child: const Icon(Icons.image_not_supported),
          );
  }
}

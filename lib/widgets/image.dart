import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as flutter;

class Image extends StatelessWidget {
  final Uint8List? image;

  const Image({super.key, this.image});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3.0 / 4.0,
      child: image != null
          ? Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: flutter.Image.memory(image!),
              ),
            )
          : const Icon(Icons.image_not_supported),
    );
  }
}

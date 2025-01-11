import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const platform = MethodChannel('com.goolnn.cangyan/picker');

Future<void> pickProjects() async {}

Future<List<MemoryImage>> pickImages() async {
  return platform
      .invokeListMethod<Uint8List>("images")
      .then<List<Uint8List>>((images) {
    return images ?? [];
  }).then((images) {
    return images.map((image) {
      return MemoryImage(image);
    }).toList();
  });
}

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const platform = MethodChannel('com.goolnn.cangyan/picker');

Future<void> pickProjects() async {}

Future<List<MemoryImage>> pickImages() async {
  switch (Platform.operatingSystem) {
    case "android":
      return platform
          .invokeListMethod<Uint8List>("images")
          .then<List<Uint8List>>((images) {
        return images ?? [];
      }).then((images) {
        return images.map((image) {
          return MemoryImage(image);
        }).toList();
      });
    case "windows":
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png'],
      );

      if (result != null) {
        return result.paths.map((path) {
          return MemoryImage(File(path!).readAsBytesSync());
        }).toList();
      }
  }

  return [];
}

import 'package:cangyan/core/frb_generated.dart';
import 'package:cangyan/pages/home.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  await RustLib.init();

  runApp(
    const MaterialApp(
      title: "苍眼",
      home: HomePage(),
    ),
  );
}

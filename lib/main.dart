import 'dart:io';

import 'package:cangyan/core/frb_generated.dart';
import 'package:cangyan/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  await RustLib.init();

  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  WidgetsFlutterBinding.ensureInitialized();

  String? workspace;

  if (Platform.isWindows) {
    workspace = "${(await getApplicationDocumentsDirectory()).path}/cangyan";
  } else if (Platform.isAndroid) {
    workspace = (await getExternalStorageDirectory())?.path;
  }

  if (workspace == null) {
    return;
  }

  runApp(
    MaterialApp(
      title: "苍眼",
      home: HomePage(
        workspace: workspace,
      ),
    ),
  );
}

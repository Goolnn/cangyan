import 'dart:io';

import 'package:cangyan/cangyan.dart' as cangyan;
import 'package:cangyan/core/frb_generated.dart';
import 'package:cangyan/utils/dirs.dart' as dirs;
import 'package:cangyan/utils/themes.dart' as themes;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  // Initialize the Rust backend library
  await RustLib.init();

  // Set the system UI overlay style
  switch (Platform.operatingSystem) {
    case "android":
      WidgetsFlutterBinding.ensureInitialized();

      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      );

      break;
  }

  // Get the workspace path
  final path = await dirs.workspace();

  // Run the app
  runApp(
    MaterialApp(
      title: "苍眼",
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('zh'),
      ],
      theme: themes.theme(),
      locale: const Locale('zh'),
      home: cangyan.HomePage(path: path),
    ),
  );
}

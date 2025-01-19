import 'dart:async';
import 'dart:io';

import 'package:cangyan/cangyan.dart' as cangyan;
import 'package:cangyan/core/frb_generated.dart';
import 'package:cangyan/utils/dirs.dart' as dirs;
import 'package:cangyan/utils/themes.dart' as themes;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:window_manager/window_manager.dart';
import 'package:windows_single_instance/windows_single_instance.dart';

final arguments = StreamController<List<String>>.broadcast();

Future<void> main(List<String> args) async {
  // Initialize the Rust backend library
  await RustLib.init();

  WidgetsFlutterBinding.ensureInitialized();

  await WindowsSingleInstance.ensureSingleInstance(
    args,
    "com.goolnn.cangyan",
    onSecondWindow: (args) {
      arguments.add(args);
    },
  );

  // Initialize the Flutter app
  switch (Platform.operatingSystem) {
    case "android":
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      );

      break;

    case "windows":
      await windowManager.ensureInitialized();

      WindowOptions windowOptions = const WindowOptions(
        title: "苍眼",
        size: Size(960, 640),
        minimumSize: Size(720, 540),
        center: true,
        backgroundColor: Colors.transparent,
        skipTaskbar: false,
        titleBarStyle: TitleBarStyle.hidden,
      );

      windowManager.waitUntilReadyToShow(windowOptions, () async {
        await windowManager.show();
      });

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
      home: cangyan.Frame(
        child: cangyan.HomePage(
          path: path,
          args: args,
        ),
      ),
    ),
  );
}

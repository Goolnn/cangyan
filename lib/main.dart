import 'dart:io';

import 'package:cangyan/core/frb_generated.dart';
import 'package:cangyan/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  await RustLib.init();

  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();

  WindowOptions options = const WindowOptions(
    size: Size(960, 720),
    minimumSize: Size(640, 480),
    center: true,
  );

  windowManager.waitUntilReadyToShow(options, () async {
    await windowManager.show();
  });

  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  String? workspace;

  if (Platform.isAndroid) {
    workspace = (await getExternalStorageDirectory())?.path;
  } else {
    workspace = "${(await getApplicationDocumentsDirectory()).path}/cangyan";

    final directory = Directory(workspace);

    if (!await directory.exists()) {
      await directory.create();
    }
  }

  if (workspace == null) {
    return;
  }

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
      locale: const Locale('zh'),
      theme: ThemeData(
        fontFamily: Platform.isAndroid ? null : "Microsoft YaHei",
      ),
      home: HomePage(
        workspace: workspace,
      ),
    ),
  );
}

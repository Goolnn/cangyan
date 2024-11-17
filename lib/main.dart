import 'dart:io';

import 'package:cangyan/core.dart' as cangyan;
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

  if (Platform.isWindows) {
    await windowManager.ensureInitialized();

    WindowOptions options = const WindowOptions(
      size: Size(960, 720),
      minimumSize: Size(640, 480),
      center: true,
    );

    windowManager.waitUntilReadyToShow(options, () async {
      await windowManager.show();
    });
  }

  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  String? path;

  if (Platform.isAndroid) {
    path = (await getExternalStorageDirectory())?.path;
  } else {
    path = "${(await getApplicationDocumentsDirectory()).path}/cangyan";

    final directory = Directory(path);

    if (!await directory.exists()) {
      await directory.create();
    }
  }

  if (path == null) {
    return;
  }

  final workspace = cangyan.Workspace(path: path);

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

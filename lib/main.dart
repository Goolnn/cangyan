import 'package:cangyan/cangyan.dart' as cangyan;
import 'package:cangyan/tools/themes.dart' as themes;
import 'package:cangyan/core/frb_generated.dart';
import 'package:cangyan/tools/dirs.dart' as dirs;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  await RustLib.init();

  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  final path = await dirs.workspace();

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

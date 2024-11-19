import 'package:cangyan/cangyan.dart' as cangyan;
import 'package:cangyan/core/frb_generated.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  await RustLib.init();

  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  final directory = (await getExternalStorageDirectory())?.path;

  if (directory == null) {
    return;
  }

  final workspace = cangyan.Workspace(path: directory);

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
      home: cangyan.HomePage(
        workspace: workspace,
      ),
    ),
  );
}

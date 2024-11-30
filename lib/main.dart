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

  final path = (await getExternalStorageDirectory())?.path;

  if (path == null) {
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
      theme: ThemeData(
        colorScheme: ColorScheme(
          primary: Colors.blue,
          onPrimary: Colors.white,
          secondary: Colors.blue.shade50,
          onSecondary: Colors.black87,
          error: Colors.red,
          onError: Colors.yellow,
          surface: Colors.white,
          onSurface: Colors.black,
          brightness: Brightness.light,
        ),
        dividerTheme: DividerThemeData(
          color: Colors.grey.shade400,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        dialogTheme: DialogTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
      locale: const Locale('zh'),
      home: cangyan.HomePage(path: path),
    ),
  );
}

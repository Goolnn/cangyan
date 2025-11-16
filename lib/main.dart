import 'dart:io';
import 'dart:ui';

import 'package:cangyan/l10n/app_localizations.dart';
import 'package:cangyan/platforms/desktop/window/frame.dart' as window;
import 'package:flutter/material.dart';
import 'package:rinf/rinf.dart';
import 'package:window_manager/window_manager.dart';

import 'src/bindings/bindings.dart';

Future<void> main() async {
  await initializeRust(assignRustSignal);

  if (Platform.isWindows) {
    WidgetsFlutterBinding.ensureInitialized();

    await windowManager.ensureInitialized();

    final windowOptions = WindowOptions(
      title: (await AppLocalizations.delegate.load(
        PlatformDispatcher.instance.locale,
      )).appTitle,
      titleBarStyle: TitleBarStyle.hidden,
      size: Size(800, 600),
      minimumSize: Size(640, 480),
      center: true,
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(
    MaterialApp(
      onGenerateTitle: (context) {
        final title = AppLocalizations.of(context)!.appTitle;

        if (Platform.isWindows) {
          windowManager.getTitle().then((current) {
            if (current != title) {
              windowManager.setTitle(title);
            }
          });
        }

        return title;
      },

      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,

      theme: ThemeData(fontFamily: "HarmonyOS Sans SC"),

      home: const Application(),
    ),
  );
}

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: window.Frame(
          child: Material(child: Center(child: Text("你好，世界！"))),
        ),
      ),
    );
  }
}

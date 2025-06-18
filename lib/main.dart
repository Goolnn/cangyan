import 'package:cangyan/src/bindings/bindings.dart';
import 'package:flutter/material.dart';
import 'package:rinf/rinf.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeRust(assignRustSignal);

  await windowManager.ensureInitialized();

  WindowOptions windowOptions = WindowOptions(
    title: "苍眼",
    size: Size(800, 600),
    minimumSize: Size(640, 480),
    center: true,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(MaterialApp(title: "苍眼", home: const Application()));
}

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: const Placeholder()));
  }
}

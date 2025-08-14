import 'dart:io';
import 'dart:ui';

import 'package:cangyan/platforms/desktop/pages/home.dart' as window;
import 'package:cangyan/platforms/desktop/window/frame.dart' as window;
import 'package:cangyan/src/bindings/bindings.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:rinf/rinf.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeRust(assignRustSignal);

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = WindowOptions(
      title: "苍眼",
      size: Size(960, 720),
      minimumSize: Size(640, 480),
      center: true,
      titleBarStyle: TitleBarStyle.hidden,
      backgroundColor: Colors.transparent,
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
    });
  }

  runApp(MaterialApp(title: "苍眼", home: const Application()));
}

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 250),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Stack(
          children: [
            DropTarget(
              onDragDone: (details) {
                Dropped(
                  paths: details.files.map((item) => item.path).toList(),
                ).sendSignalToRust();
              },
              onDragEntered: (details) {
                _controller.forward();
              },
              onDragExited: (details) {
                _controller.reverse();
              },
              child: window.Frame(child: window.HomePage()),
            ),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return IgnorePointer(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 4.0 * _animation.value,
                      sigmaY: 4.0 * _animation.value,
                    ),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.black.withAlpha(
                        (255.0 * 0.25 * _animation.value).toInt(),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.file_upload_outlined,
                          size: 96.0,
                          color: Colors.white.withAlpha(
                            (255.0 * _animation.value).toInt(),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cangyan/src/bindings/bindings.dart';
import 'package:window_manager/window_manager.dart';

class ArgsPage extends StatefulWidget {
  const ArgsPage({super.key});

  @override
  State<ArgsPage> createState() => _ArgsPageState();
}

class _ArgsPageState extends State<ArgsPage> {
  String _args = '';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder(
        stream: Arguments.rustSignalStream,
        builder: (context, snapshot) {
          final pack = snapshot.data;

          if (pack != null) {
            for (var arg in pack.message.value) {
              _args += '$arg\n';
            }

            windowManager.show();
          }

          return Text(_args);
        },
      ),
    );
  }
}

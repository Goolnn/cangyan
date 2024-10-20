import 'package:cangyan/core/frb_generated.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  await RustLib.init();

  runApp(const MaterialApp(home: HomePage()));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Text('Hello, world!'),
        ),
      ),
    );
  }
}

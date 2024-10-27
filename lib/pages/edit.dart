import 'package:flutter/material.dart';

class EditPage extends StatelessWidget {
  const EditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: InteractiveViewer(
          minScale: 0.1,
          maxScale: 10.0,
          child: const Placeholder(),
        ),
      ),
    );
  }
}

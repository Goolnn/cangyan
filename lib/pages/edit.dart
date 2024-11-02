import 'package:cangyan/core/api/cyfile/page.dart' as cangyan;
import 'package:flutter/material.dart';

class EditPage extends StatelessWidget {
  final cangyan.Page page;

  const EditPage({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: InteractiveViewer(
          child: Center(
            child: Image(
              image: MemoryImage(page.data),
            ),
          ),
        ),
      ),
    );
  }
}

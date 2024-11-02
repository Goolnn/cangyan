import 'package:cangyan/core/api/cyfile/page.dart' as cangyan;
import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  final cangyan.Page page;

  const EditPage({super.key, required this.page});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: InteractiveViewer(
          child: Center(
            child: Image(
              image: MemoryImage(widget.page.data),
            ),
          ),
        ),
      ),
    );
  }
}

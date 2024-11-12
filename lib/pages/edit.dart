import 'package:cangyan/core/states.dart' as cangyan;
import 'package:cangyan/core/file.dart' as cangyan;
import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  final cangyan.EditState state;

  const EditPage({
    super.key,
    required this.state,
  });

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late cangyan.Page page;

  @override
  void initState() {
    super.initState();

    page = widget.state.page()!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: precacheImage(
            MemoryImage(page.data),
            context,
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return InteractiveViewer(
              maxScale: 10.0,
              child: Center(
                child: Image.memory(
                  page.data,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

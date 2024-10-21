import 'package:cangyan/core/api/states/home.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeState? state;

  @override
  void initState() {
    super.initState();

    _initState();
  }

  Future<void> _initState() async {
    final workspace = await getExternalStorageDirectory();

    if (workspace == null) {
      return;
    }

    setState(() {
      state = HomeState(workspace: workspace.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (state == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: const SafeArea(
        child: Center(
          child: Text('Hello, world!'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}

import 'package:cangyan/platforms/desktop/widgets/search_box.dart';
import 'package:cangyan/platforms/desktop/window/button.dart' as window;
import 'package:cangyan/platforms/desktop/window/frame.dart' as window;
import 'package:cangyan/platforms/desktop/window/page.dart' as window;
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _searchText = '';

  @override
  Widget build(BuildContext context) {
    return window.Page(
      buttons: [
        window.Button(
          onPressed: () {},
          child: Icon(Icons.menu, size: window.kWindowTitleBarHeight * 0.4),
        ),
      ],
      panel: FractionallySizedBox(
        widthFactor: 0.50,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: SearchBox(
            onChanged: (text) {
              setState(() {
                _searchText = text;
              });
            },
          ),
        ),
      ),
      child: Scaffold(
        body: Center(
          child: Text(_searchText.isEmpty ? '首页' : '搜索：$_searchText'),
        ),
      ),
    );
  }
}

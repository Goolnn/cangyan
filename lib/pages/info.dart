import 'package:cangyan/core/api/states/home.dart';
import 'package:cangyan/core/api/states/info.dart';
import 'package:flutter/material.dart';

class InfoPage extends StatefulWidget {
  final InfoState state;

  InfoPage({super.key, required Summary summary}) : state = summary.open();

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    final pages = widget.state.pages();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 256.0 + 32.0,
                    child: AspectRatio(
                      aspectRatio: 3.0 / 4.0,
                      child: widget.state.cover() != null
                          ? Image.memory(widget.state.cover()!)
                          : const Placeholder(),
                    ),
                  ),
                  Text(
                    widget.state.title(),
                    style: const TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  Wrap(
                    children: [
                      for (int i = 0; i < pages.length; i++)
                        FractionallySizedBox(
                          widthFactor: 1.0 / 3.0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                AspectRatio(
                                  aspectRatio: 3.0 / 4.0,
                                  child: Image.memory(pages[i]),
                                ),
                                const SizedBox(height: 4.0),
                                Text('第 ${i + 1} 页'),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

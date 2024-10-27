import 'dart:typed_data';

import 'package:cangyan/core/api/states/home.dart';
import 'package:cangyan/core/api/states/info.dart';
import 'package:cangyan/pages/edit.dart';
import 'package:cangyan/widgets/image.dart' as cangyan;
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
                    height: 256.0,
                    child: cangyan.Image(image: widget.state.cover()),
                  ),
                  const Divider(),
                  Text(
                    widget.state.title(),
                    style: const TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  const Divider(),
                  Wrap(
                    children: [
                      for (int index = 0; index < pages.length; index++)
                        _Page(image: pages[index], index: index),
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

class _Page extends StatelessWidget {
  final int columnCount = 3;

  final Uint8List image;
  final int index;

  const _Page({
    required this.image,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1.0 / columnCount,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 3.0 / 4.0,
              child: Stack(
                children: [
                  cangyan.Image(image: image),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      focusColor: Colors.grey.withOpacity(0.15),
                      highlightColor: Colors.grey.withOpacity(0.15),
                      hoverColor: Colors.grey.withOpacity(0.15),
                      splashColor: Colors.grey.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8.0),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return const EditPage();
                          },
                        ));
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4.0),
            Text('第${index + 1}页'),
          ],
        ),
      ),
    );
  }
}

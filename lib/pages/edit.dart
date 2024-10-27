import 'dart:typed_data';

import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  final Uint8List image;

  const EditPage({super.key, required this.image});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final TransformationController _controller = TransformationController();

  double _scale = 1.0;

  @override
  void initState() {
    super.initState();

    _controller.addListener(_onTransformChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTransformChanged);
    _controller.dispose();

    super.dispose();
  }

  void _onTransformChanged() {
    setState(() {
      _scale = _controller.value.getMaxScaleOnAxis();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: InteractiveViewer(
                    transformationController: _controller,
                    maxScale: 10.0,
                    child: Image.memory(widget.image),
                  ),
                ),
              ],
            ),
            if (_scale != 1.0)
              Positioned(
                top: 16.0,
                left: 16.0,
                child: Card(
                  shape: const StadiumBorder(),
                  color: Colors.black.withOpacity(0.15),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 6.0,
                    ),
                    child: Text(
                      '×${_scale.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

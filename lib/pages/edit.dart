import 'package:cangyan/core/api/cyfile/note.dart';
import 'package:cangyan/core/api/cyfile/page.dart' as cangyan;
import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  final cangyan.Page page;

  const EditPage({super.key, required this.page});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _controller = TransformationController();

  final _containerKey = GlobalKey();
  final _imageKey = GlobalKey();

  double? containerWidth;
  double? containerHeight;

  double? imageWidth;
  double? imageHeight;

  double scale = 1.0;

  double offsetX = 0.0;
  double offsetY = 0.0;

  double noteSize = 36.0;

  late List<Note> notes;

  @override
  void initState() {
    super.initState();

    _controller.addListener(_onTransformationChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final containerObject = _containerKey.currentContext?.findRenderObject();
      final imageObject = _imageKey.currentContext?.findRenderObject();

      final containerBox = containerObject as RenderBox;
      final imageBox = imageObject as RenderBox;

      final Size containerSize = containerBox.size;
      final Size imageSize = imageBox.size;

      setState(() {
        containerWidth = containerSize.width;
        containerHeight = containerSize.height;

        imageWidth = imageSize.width;
        imageHeight = imageSize.height;
      });
    });

    notes = widget.page.notes;
  }

  @override
  void dispose() {
    _controller.removeListener(_onTransformationChanged);
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            InteractiveViewer(
              transformationController: _controller,
              maxScale: 10.0,
              child: Center(
                key: _containerKey,
                child: Image(
                  key: _imageKey,
                  image: MemoryImage(widget.page.data),
                ),
              ),
            ),
            if (containerWidth != null &&
                imageWidth != null &&
                containerHeight != null &&
                imageHeight != null)
              for (int i = 0; i < notes.length; i++)
                Builder(builder: (context) {
                  final centerX = (containerWidth! - noteSize) / 2.0 + offsetX;
                  final centerY = (containerHeight! - noteSize) / 2.0 + offsetY;

                  return Positioned(
                    left: centerX + notes[i].x * imageWidth! * scale / 2.0,
                    top: centerY - notes[i].y * imageHeight! * scale / 2.0,
                    child: SizedBox(
                      width: noteSize,
                      height: noteSize,
                      child: Card(
                        shape: const CircleBorder(),
                        color: Colors.red.withOpacity(0.75),
                        child: Center(
                          child: Text(
                            '${i + 1}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }

  void _onTransformationChanged() {
    Matrix4 matrix = _controller.value;

    double scale = matrix.getMaxScaleOnAxis();

    double centerX = containerWidth! * (scale - 1.0) / 2.0;
    double centerY = containerHeight! * (scale - 1.0) / 2.0;

    double offsetX = matrix.getTranslation().x + centerX;
    double offsetY = matrix.getTranslation().y + centerY;

    setState(() {
      this.scale = scale;

      this.offsetX = offsetX;
      this.offsetY = offsetY;
    });
  }
}

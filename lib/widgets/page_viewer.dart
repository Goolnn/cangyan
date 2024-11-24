import 'dart:math';

import 'package:cangyan/cangyan.dart' as cangyan;
import 'package:flutter/material.dart';

class PageViewer extends StatefulWidget {
  final PageViewerController? controller;

  final MemoryImage image;
  final List<cangyan.Note> notes;

  final void Function(int index, cangyan.Note note)? onNoteTap;

  const PageViewer({
    super.key,
    this.controller,
    required this.image,
    required this.notes,
    this.onNoteTap,
  });

  @override
  State<PageViewer> createState() => _PageViewerState();
}

class _PageViewerState extends State<PageViewer> {
  final viewerController = TransformationController();

  late final PageViewerController controller;

  Size? imageSize;

  late Size viewerSize;
  late Size pageSize;

  @override
  void initState() {
    super.initState();

    controller = widget.controller ?? PageViewerController();
    controller.addListener(
      () => setState(() {
        final scale = controller.scale;

        final center = Offset(
          viewerSize.width * (scale - 1.0) / 2.0,
          viewerSize.height * (scale - 1.0) / 2.0,
        );

        final offset = Offset(
          -controller.x * pageSize.width * scale / 2.0 - center.dx,
          controller.y * pageSize.height * scale / 2.0 - center.dy,
        );

        final matrix = Matrix4.identity()
          ..translate(offset.dx, offset.dy)
          ..scale(scale);

        viewerController.value = matrix;
      }),
    );

    widget.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((info, synchronousCall) {
        final imageSize = Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        );

        setState(() {
          this.imageSize = imageSize;
        });
      }),
    );

    viewerController.addListener(() {
      final matrix = viewerController.value;

      final scale = matrix.getMaxScaleOnAxis();

      final center = Offset(
        viewerSize.width * (scale - 1.0) / 2.0,
        viewerSize.height * (scale - 1.0) / 2.0,
      );

      final offset = Offset(
        matrix.getTranslation().x + center.dx,
        matrix.getTranslation().y + center.dy,
      );

      final position = Offset(
        -offset.dx / pageSize.width / scale * 2.0,
        offset.dy / pageSize.height / scale * 2.0,
      );

      controller.scale = scale;

      controller.x = position.dx;
      controller.y = position.dy;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (imageSize == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        viewerSize = Size(
          constraints.maxWidth,
          constraints.maxHeight,
        );

        final hertRadio = viewerSize.width / imageSize!.width;
        final vertRadio = viewerSize.height / imageSize!.height;

        final radio = min(hertRadio, vertRadio);

        pageSize = Size(
          imageSize!.width * radio,
          imageSize!.height * radio,
        );

        final halfScaledPageSize = Size(
          pageSize.width / controller.scale / 2.0,
          pageSize.height / controller.scale / 2.0,
        );

        final diffSize = Size(
          viewerSize.width - pageSize.width,
          viewerSize.height - pageSize.height,
        );

        final factor = (1 - 1 / controller.scale) / 2.0;

        final symmetric = Size(
          halfScaledPageSize.width - (diffSize.width * factor),
          halfScaledPageSize.height - (diffSize.height * factor),
        );

        final margin = EdgeInsets.symmetric(
          horizontal: symmetric.width,
          vertical: symmetric.height,
        );

        return Stack(
          fit: StackFit.expand,
          children: [
            InteractiveViewer(
              transformationController: viewerController,
              maxScale: 10.0,
              minScale: 0.5,
              boundaryMargin: margin,
              child: Center(
                child: Image(
                  image: widget.image,
                ),
              ),
            ),
            for (int i = 0; i < widget.notes.length; i++)
              Builder(builder: (context) {
                final center = Point(
                  viewerSize.width / 2.0 + controller.x,
                  viewerSize.height / 2.0 + controller.y,
                );

                final offset = Offset(
                  (widget.notes[i].x - controller.x) *
                      pageSize.width *
                      controller.scale /
                      2.0,
                  (widget.notes[i].y - controller.y) *
                      pageSize.height *
                      controller.scale /
                      2.0,
                );

                const size = 16.0;

                return Positioned(
                  left: center.x + offset.dx - size,
                  top: center.y - offset.dy - size,
                  child: cangyan.Mark(
                    index: i + 1,
                    size: size,
                    onPressed: () {
                      if (widget.onNoteTap != null) {
                        widget.onNoteTap!(i, widget.notes[i]);
                      }
                    },
                  ),
                );
              }),
          ],
        );
      },
    );
  }
}

class PageViewerController extends ChangeNotifier {
  late double _x;
  late double _y;

  late double _scale;

  PageViewerController({
    double x = 0.0,
    double y = 0.0,
    double scale = 1.0,
  }) {
    _x = x;
    _y = y;

    _scale = scale;
  }

  double get x => _x;
  double get y => _y;

  double get scale => _scale;

  set x(double x) {
    _x = x;

    notifyListeners();
  }

  set y(double y) {
    _y = y;

    notifyListeners();
  }

  set scale(double scale) {
    _scale = scale;

    notifyListeners();
  }
}

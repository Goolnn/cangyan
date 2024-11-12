import 'dart:math';

import 'package:cangyan/core/cyfile.dart' as cangyan;
import 'package:cangyan/core/states.dart' as cangyan;
import 'package:cangyan/widgets.dart' as cangyan;
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
  final viewerController = TransformationController();
  final viewerKey = GlobalKey();

  late cangyan.Page page;

  double scale = 1.0;

  Offset offset = Offset.zero;

  bool openPad = false;
  bool editing = false;

  int index = 0;

  Size? viewerSize;
  Size? imageSize;
  Size? pageSize;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewer = viewerKey.currentContext?.findRenderObject() as RenderBox;

      setState(() {
        viewerSize = viewer.size;
      });
    });

    viewerController.addListener(() {
      if (viewerSize == null) {
        return;
      }

      Matrix4 matrix = viewerController.value;

      double scale = matrix.getMaxScaleOnAxis();

      double centerX = viewerSize!.width * (scale - 1.0) / 2.0;
      double centerY = viewerSize!.height * (scale - 1.0) / 2.0;

      double offsetX = matrix.getTranslation().x + centerX;
      double offsetY = matrix.getTranslation().y + centerY;

      setState(() {
        this.scale = scale;

        offset = Offset(
          offsetX,
          offsetY,
        );
      });
    });

    page = widget.state.page()!;
  }

  @override
  void dispose() {
    viewerController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final image = MemoryImage(page.data);

    image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
        (info, _) {
          setState(() {
            imageSize = Size(
              info.image.width.toDouble(),
              info.image.height.toDouble(),
            );
          });
        },
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            GestureDetector(
              onDoubleTap: () {
                viewerController.value = Matrix4.identity();
              },
              child: Builder(
                builder: (context) {
                  var margin = EdgeInsets.zero;

                  if (pageSize != null) {
                    final halfScaledPageSize = Size(
                      pageSize!.width / scale / 2.0,
                      pageSize!.height / scale / 2.0,
                    );

                    final diffSize = Size(
                      viewerSize!.width - pageSize!.width,
                      viewerSize!.height - pageSize!.height,
                    );

                    final factor = (1 - 1 / scale) / 2.0;

                    final symmetric = Size(
                      halfScaledPageSize.width - (diffSize.width * factor),
                      halfScaledPageSize.height - (diffSize.height * factor),
                    );

                    margin = EdgeInsets.symmetric(
                      horizontal: symmetric.width,
                      vertical: symmetric.height,
                    );
                  }

                  return InteractiveViewer(
                    key: viewerKey,
                    transformationController: viewerController,
                    minScale: 1.0,
                    maxScale: 10.0,
                    boundaryMargin: margin,
                    child: Center(
                      child: Image(
                        image: image,
                      ),
                    ),
                  );
                },
              ),
            ),
            for (int i = 0; i < page.notes.length; i++)
              Builder(
                builder: (context) {
                  if (viewerSize == null || imageSize == null) {
                    return Container();
                  }

                  if (pageSize == null) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      final hertRadio = viewerSize!.width / imageSize!.width;
                      final vertRadio = viewerSize!.height / imageSize!.height;

                      final scale = min(hertRadio, vertRadio);

                      setState(() {
                        pageSize = Size(
                          imageSize!.width * scale,
                          imageSize!.height * scale,
                        );
                      });
                    });

                    return Container();
                  } else {
                    final center = Point(
                      viewerSize!.width / 2.0 + this.offset.dx,
                      viewerSize!.height / 2.0 + this.offset.dy,
                    );

                    final offset = Offset(
                      page.notes[i].x * pageSize!.width * scale / 2.0,
                      page.notes[i].y * pageSize!.height * scale / 2.0,
                    );

                    return Positioned(
                      left: center.x + offset.dx,
                      top: center.y - offset.dy,
                      child: cangyan.Mark(
                        index: i + 1,
                        onPressed: () {
                          setState(() {
                            openPad = true;
                            index = i;
                          });
                        },
                      ),
                    );
                  }
                },
              ),
            if (scale != 1.0)
              Positioned(
                top: 16.0,
                left: 16.0,
                child: cangyan.Capsule(
                  child: Text('×${scale.toStringAsFixed(2)}'),
                ),
              ),
            if (viewerSize != null)
              Builder(builder: (context) {
                final padWidth = viewerSize!.width;
                final padHeight = viewerSize!.height / (editing ? 8.0 : 3.0);

                return PopScope(
                  canPop: false,
                  onPopInvokedWithResult: (didPop, result) {
                    if (didPop || editing) {
                      return;
                    }

                    if (openPad) {
                      setState(() {
                        openPad = false;
                      });
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: AnimatedPositioned(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOutCubic,
                    bottom: openPad
                        ? MediaQuery.of(context).viewInsets.bottom
                        : -padWidth,
                    width: padWidth,
                    height: padHeight,
                    child: cangyan.TextPad(
                      notes: page.notes,
                      index: index,
                      onEditing: () {
                        setState(() {
                          editing = true;
                        });
                      },
                      onSubmitted: () {
                        setState(() {
                          editing = false;
                        });
                      },
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}

import 'dart:math';

import 'package:cangyan/cangyan.dart' as cangyan;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditPage extends StatefulWidget {
  final MemoryImage image;

  final cangyan.Editor editor;

  const EditPage(
    this.image, {
    super.key,
    required this.editor,
  });

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final drawerController = cangyan.DrawerController();
  final viewerController = TransformationController();
  final viewerKey = GlobalKey();

  late List<cangyan.Note> notes;

  double scale = 1.0;

  Offset offset = Offset.zero;

  int index = 0;

  Size? viewerSize;
  Size? imageSize;
  Size? pageSize;

  Offset? draggingStart;
  Offset? draggingOffset;

  bool dragging = false;

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

    widget.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
        (info, synchronousCall) {
          setState(() {
            imageSize = Size(
              info.image.width.toDouble(),
              info.image.height.toDouble(),
            );
          });
        },
      ),
    );

    notes = widget.editor.notes();
  }

  @override
  void dispose() {
    viewerController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: cangyan.Drawer(
          controller: drawerController,
          board: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                ),
                child: Row(
                  children: [
                    IconButton(
                      style: TextButton.styleFrom(
                        minimumSize: const Size.fromRadius(18.0),
                        shape: const CircleBorder(),
                        foregroundColor: Colors.black,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.arrow_left),
                    ),
                    const Spacer(),
                    TextButton(
                      style: TextButton.styleFrom(
                        minimumSize: const Size.fromRadius(18.0),
                        shape: const CircleBorder(),
                        foregroundColor: Colors.black,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () {},
                      child: const Text('1'),
                    ),
                    const Spacer(),
                    IconButton(
                      style: TextButton.styleFrom(
                        minimumSize: const Size.fromRadius(18.0),
                        shape: const CircleBorder(),
                        foregroundColor: Colors.black,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.arrow_right),
                    ),
                  ],
                ),
              ),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Spacer(),
                      VerticalDivider(),
                      Spacer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
                    } else if (imageSize != null && viewerSize != null) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        final hertRadio = viewerSize!.width / imageSize!.width;
                        final vertRadio =
                            viewerSize!.height / imageSize!.height;

                        final scale = min(hertRadio, vertRadio);

                        setState(() {
                          pageSize = Size(
                            imageSize!.width * scale,
                            imageSize!.height * scale,
                          );
                        });
                      });
                    }

                    return InteractiveViewer(
                      key: viewerKey,
                      transformationController: viewerController,
                      minScale: 0.5,
                      maxScale: 10.0,
                      scaleFactor: 500.0,
                      boundaryMargin: margin,
                      child: Center(
                        child: GestureDetector(
                          onLongPressStart: (details) {
                            final position = details.localPosition;
                            final coordiante = Offset(
                              (position.dx / pageSize!.width * 2.0 - 1.0),
                              -(position.dy / pageSize!.height * 2.0 - 1.0),
                            );

                            HapticFeedback.selectionClick();

                            widget.editor.appendNote(
                              x: coordiante.dx,
                              y: coordiante.dy,
                            );

                            setState(() {
                              notes.add(cangyan.Note(
                                x: coordiante.dx,
                                y: coordiante.dy,
                                choice: 0,
                                texts: [
                                  cangyan.Text(
                                    content: '',
                                    comment: '',
                                  )
                                ],
                              ));
                            });
                          },
                          child: Image(
                            image: widget.image,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              for (int i = 0; i < notes.length; i++)
                Builder(
                  builder: (context) {
                    if (viewerSize == null ||
                        imageSize == null ||
                        pageSize == null) {
                      return Container();
                    }

                    final center = Point(
                      viewerSize!.width / 2.0 + this.offset.dx,
                      viewerSize!.height / 2.0 + this.offset.dy,
                    );

                    final offset = Offset(
                      notes[i].x * pageSize!.width * scale / 2.0,
                      notes[i].y * pageSize!.height * scale / 2.0,
                    );

                    const size = 16.0;

                    return Positioned(
                      left: center.x + offset.dx - size,
                      top: center.y - offset.dy - size,
                      child: cangyan.Mark(
                        index: i + 1,
                        size: size,
                        onPressed: () {
                          setState(() {
                            drawerController.show();

                            index = i;
                          });
                        },
                        onLongPressed: () {
                          setState(() {
                            drawerController.hide();
                          });

                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('删除'),
                                content: const Text('确认删除这个标记吗？'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('取消'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      if (index == i) {
                                        setState(() {
                                          index = 0;
                                        });
                                      }

                                      widget.editor.removeNote(
                                        index: BigInt.from(i),
                                      );

                                      setState(() {
                                        notes.removeAt(i);
                                      });

                                      Navigator.pop(context);
                                    },
                                    child: const Text('确认'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        onPanStart: (detail) {
                          draggingStart = Offset(
                            notes[i].x,
                            notes[i].y,
                          );
                        },
                        onPanEnd: (detail) {
                          draggingStart = null;
                          draggingOffset = null;

                          dragging = false;

                          widget.editor.updateNotePosition(
                            index: BigInt.from(i),
                            x: notes[i].x,
                            y: notes[i].y,
                          );
                        },
                        onPanUpdate: (detail) {
                          final position = Offset(
                            detail.localPosition.dx - size,
                            detail.localPosition.dy - size,
                          );

                          const radius = 60.0;

                          if (!dragging && position.distance >= radius) {
                            draggingOffset = position;

                            dragging = true;
                          }

                          if (dragging) {
                            var coordiante = Offset(
                              ((position.dx - draggingOffset!.dx) /
                                  pageSize!.width /
                                  scale *
                                  2.0),
                              -((position.dy - draggingOffset!.dy) /
                                  pageSize!.height /
                                  scale *
                                  2.0),
                            );

                            setState(() {
                              var noteX = draggingStart!.dx + coordiante.dx;
                              var noteY = draggingStart!.dy + coordiante.dy;

                              if (noteX.abs() > 1.0) {
                                noteX = noteX.sign;
                              }

                              if (noteY.abs() > 1.0) {
                                noteY = noteY.sign;
                              }

                              notes[i].x = noteX;
                              notes[i].y = noteY;
                            });
                          }
                        },
                      ),
                    );
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
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ImageViewer extends StatefulWidget {
  final int count;

  final void Function(int from, int to)? onReorder;

  final List<Widget> children;

  const ImageViewer({
    super.key,
    this.count = 3,
    this.onReorder,
    required this.children,
  });

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  int? dragging;
  int? hover;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Align(
        alignment: Alignment.topLeft,
        child: Wrap(children: [
          for (var i = 0; i < widget.children.length; i++)
            Builder(builder: (context) {
              final image = SizedBox(
                width: constraints.maxWidth / widget.count,
                child: widget.children[i],
              );

              return DragTarget<int>(
                onWillAcceptWithDetails: (details) {
                  setState(() {
                    hover = i;
                  });

                  return true;
                },
                onLeave: (data) {
                  setState(() {
                    hover = null;
                  });
                },
                onAcceptWithDetails: (details) {
                  setState(() {
                    hover = null;
                  });

                  final from = details.data;
                  final to = i;

                  final image = widget.children.removeAt(from);

                  widget.children.insert(to, image);

                  widget.onReorder?.call(from, to);
                },
                builder: (context, candidateData, rejectedData) {
                  return Column(children: [
                    Opacity(
                      opacity: dragging == i ? 0.125 : (hover == i ? 0.5 : 1.0),
                      child: image,
                    ),
                    LongPressDraggable(
                      data: i,
                      maxSimultaneousDrags: 1,
                      dragAnchorStrategy: (draggable, context, position) {
                        return Offset(
                          constraints.maxWidth / 3.0 / 2.0,
                          constraints.maxWidth / 3.0 / 3.0 * 4.0 + 8.0,
                        );
                      },
                      onDragStarted: () {
                        setState(() {
                          dragging = i;
                        });
                      },
                      onDragEnd: (details) {
                        setState(() {
                          dragging = null;
                          hover = null;
                        });
                      },
                      feedback: Transform.scale(
                        scale: 0.90,
                        child: image,
                      ),
                      child: Text('第${i + 1}页'),
                    ),
                  ]);
                },
              );
            })
        ]),
      );
    });
  }
}

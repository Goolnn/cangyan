import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class EditView extends StatefulWidget {
  final String path;

  final Image image;

  final int index;

  const EditView({
    super.key,

    required this.path,

    required this.image,

    required this.index,
  });

  @override
  State<EditView> createState() => _EditViewState();
}

class _EditViewState extends State<EditView> {
  Offset _offset = Offset.zero;
  double _scale = 1.0;

  Offset _startPosition = Offset.zero;
  Offset _startOffset = Offset.zero;

  Size? _imageSize;

  @override
  void initState() {
    super.initState();

    widget.image.image
        .resolve(const ImageConfiguration())
        .addListener(
          ImageStreamListener((info, _) {
            setState(() {
              _imageSize = Size(
                info.image.width.toDouble(),
                info.image.height.toDouble(),
              );
            });
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final layoutSize = Size(constraints.maxWidth, constraints.maxHeight);

        Size? imageSize;

        if (_imageSize != null) {
          final source = _imageSize!.width / _imageSize!.height;
          final target = layoutSize.width / layoutSize.height;

          if (source > target) {
            final width = layoutSize.width;
            final height = width / source;

            imageSize = Size(width, height) * _scale;
          } else {
            final width = layoutSize.height;
            final height = width * source;

            imageSize = Size(height, width) * _scale;
          }
        }

        return GestureDetector(
          behavior: HitTestBehavior.translucent,

          onDoubleTap: () {
            setState(() {
              _offset = Offset.zero;
              _scale = 1.0;
            });
          },

          child: Listener(
            behavior: HitTestBehavior.translucent,

            onPointerSignal: (event) {
              if (event is PointerScrollEvent) {
                setState(() {
                  event.scrollDelta.dy < 0 ? _scale *= 1.15 : _scale /= 1.15;

                  _scale = _scale.clamp(0.25, 25.0);
                });
              }
            },

            onPointerDown: (event) {
              if (imageSize == null) return;

              _startPosition = event.localPosition;
              _startOffset = _offset;
            },

            onPointerMove: (event) {
              final current = event.localPosition;

              final dx = current.dx - _startPosition.dx;
              final dy = current.dy - _startPosition.dy;

              final size = imageSize!;

              final deltaX = (dx / size.width) * 2.0;
              final deltaY = (dy / size.height) * 2.0;

              setState(() {
                _offset = Offset(
                  (_startOffset.dx - deltaX).clamp(-1.0, 1.0),
                  (_startOffset.dy + deltaY).clamp(-1.0, 1.0),
                );
              });
            },

            child: Transform(
              transform: Matrix4.identity()
                ..translate(
                  -_offset.dx * ((imageSize?.width ?? 0) / 2),
                  _offset.dy * ((imageSize?.height ?? 0) / 2),
                )
                ..translate(
                  (layoutSize.width - layoutSize.width * _scale) / 2.0,
                  (layoutSize.height - layoutSize.height * _scale) / 2.0,
                )
                ..scale(_scale),

              child: Hero(
                tag: 'page_${widget.path}_${widget.index}',

                child: FittedBox(
                  fit: BoxFit.contain,

                  child: ClipRSuperellipse(
                    borderRadius: BorderRadius.circular(12.0),
                    child: widget.image,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

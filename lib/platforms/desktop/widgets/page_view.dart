import 'dart:math';
import 'dart:typed_data';

import 'package:cangyan/platforms/desktop/pages/edit.dart' as pages;
import 'package:cangyan/src/bindings/bindings.dart' as signals;
import 'package:flutter/material.dart';

class PageView extends StatefulWidget {
  final String path;

  final int pageCount;

  const PageView({super.key, required this.path, required this.pageCount});

  @override
  State<PageView> createState() => _PageViewState();
}

class _PageViewState extends State<PageView> {
  List<Image>? _images;

  @override
  void initState() {
    super.initState();

    signals.Open(path: widget.path).sendSignalToRust();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: signals.Pages.rustSignalStream,

      builder: (context, snapshot) {
        final data = snapshot.data;
        final images = data?.message.value;

        _images ??= images?.map((page) {
          return Image.memory(
            Uint8List.fromList(page),

            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              return AnimatedOpacity(
                opacity: frame == null ? 0.0 : 1.0,
                duration: Duration(milliseconds: 250),

                child: child,
              );
            },
          );
        }).toList();

        return LayoutBuilder(
          builder: (context, constraints) {
            final cardSize = 128.0 + 64.0 + 32.0;
            final cardAspect = 3.0 / 4.0;

            final layoutWidth = constraints.maxWidth;

            final spacing = 16.0;
            final size = cardSize * cardAspect;

            final count = min(
              ((layoutWidth - spacing) / (size + spacing)).toInt(),
              widget.pageCount,
            );

            final width = (layoutWidth - spacing * (count + 1)) / count;
            final height = size / cardAspect;

            final aspect = width / height;

            return GridView.builder(
              padding: EdgeInsets.all(spacing),

              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: count,
                mainAxisSpacing: spacing,
                crossAxisSpacing: spacing,
                childAspectRatio: aspect,
              ),

              itemCount: widget.pageCount,

              shrinkWrap: true,

              itemBuilder: (context, index) {
                if (_images == null) {
                  return Column(
                    spacing: 8.0,

                    children: [
                      Flexible(
                        child: AspectRatio(
                          aspectRatio: 3.0 / 4.0,

                          child: Center(
                            child: SizedBox.square(
                              dimension: 16.0,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ),
                      ),

                      Text('第${index + 1}页'),
                    ],
                  );
                }

                final images = _images!;

                return Column(
                  spacing: 8.0,

                  children: [
                    Flexible(
                      child: AspectRatio(
                        aspectRatio: 3.0 / 4.0,

                        child: Stack(
                          children: [
                            Center(
                              child: Hero(
                                tag: 'page_${widget.path}_$index',

                                child: ClipRSuperellipse(
                                  borderRadius: BorderRadius.circular(12.0),

                                  child: images[index],
                                ),
                              ),
                            ),

                            RawMaterialButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),

                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,

                              hoverColor: Colors.black.withValues(alpha: 0.035),
                              highlightColor: Colors.black.withValues(
                                alpha: 0.05,
                              ),
                              splashColor: Colors.transparent,

                              onPressed: () async {
                                if (_images == null) {
                                  return;
                                }

                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (
                                          context,
                                          animation,
                                          secondaryAnimation,
                                        ) {
                                          return FadeTransition(
                                            opacity: animation,

                                            child: pages.EditPage(
                                              path: widget.path,

                                              images: images,

                                              initialIndex: index,
                                            ),
                                          );
                                        },
                                  ),
                                );
                              },

                              child: SizedBox.expand(),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Text('第${index + 1}页'),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}

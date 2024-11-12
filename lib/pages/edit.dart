import 'dart:math';

import 'package:cangyan/core/file.dart' as cangyan;
import 'package:cangyan/core/states.dart' as cangyan;
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
  final viewerKey = GlobalKey();

  late cangyan.Page page;

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

    page = widget.state.page()!;
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
      body: SafeArea(
        child: Stack(
          children: [
            Builder(
              builder: (context) {
                var margin = EdgeInsets.zero;

                if (pageSize != null) {
                  const scale = 1.0;

                  final halfScaledPageSize = Size(
                    pageSize!.width / scale / 2.0,
                    pageSize!.height / scale / 2.0,
                  );

                  final diffSize = Size(
                    viewerSize!.width - pageSize!.width,
                    viewerSize!.height - pageSize!.height,
                  );

                  const factor = (1 - 1 / scale) / 2.0;

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
            Builder(
              builder: (context) {
                if (viewerSize == null || imageSize == null) {
                  return Container();
                }

                if (pageSize == null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    final widthRatio = viewerSize!.width / imageSize!.width;
                    final heightRatio = viewerSize!.height / imageSize!.height;

                    final scale = min(widthRatio, heightRatio);

                    setState(() {
                      pageSize = Size(
                        imageSize!.width * scale,
                        imageSize!.height * scale,
                      );
                    });
                  });
                }

                return Center(
                  child: SizedBox.fromSize(
                    size: pageSize,
                    child: const Placeholder(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:math';

import 'package:cangyan/core/states.dart' as cangyan;
import 'package:cangyan/core/file.dart' as cangyan;
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
                return InteractiveViewer(
                  key: viewerKey,
                  minScale: 1.0,
                  maxScale: 10.0,
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

                final widthRatio = viewerSize!.width / imageSize!.width;
                final heightRatio = viewerSize!.height / imageSize!.height;

                final scale = min(widthRatio, heightRatio);

                pageSize = Size(
                  imageSize!.width * scale,
                  imageSize!.height * scale,
                );

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

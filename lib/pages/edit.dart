import 'package:cangyan/core/file.dart' as cangyan;
import 'package:cangyan/widgets.dart' as cangyan;
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

  int drawer = 0;

  late List<cangyan.Note> notes;

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
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final drawerWidth = constraints.maxWidth;
            final drawerHeight = constraints.maxHeight / 3.0;

            return Stack(
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
                      final centerX = containerWidth! / 2.0 + offsetX;
                      final centerY = containerHeight! / 2.0 + offsetY;

                      return Positioned(
                        left: centerX + notes[i].x * imageWidth! * scale / 2.0,
                        top: centerY - notes[i].y * imageHeight! * scale / 2.0,
                        child: cangyan.Mark(
                          index: i + 1,
                          isDone: notes[i].choice != 0,
                          onPressed: () {
                            setState(() {
                              drawer = i + 1;
                            });
                          },
                        ),
                      );
                    }),
                if (scale != 1.0)
                  Positioned(
                    top: 16.0,
                    left: 16.0,
                    child: cangyan.Capsule(
                      child: Text('×${scale.toStringAsFixed(2)}'),
                    ),
                  ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutCubic,
                  bottom: drawer != 0
                      ? MediaQuery.of(context).viewInsets.bottom
                      : -drawerWidth,
                  width: drawerWidth,
                  height: drawerHeight,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        drawer = 0;
                      });
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              if (drawer != 0)
                                for (int i = 0;
                                    i < notes[drawer - 1].texts.length;
                                    i++)
                                  Card(
                                    elevation: 4.0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(notes[drawer - 1]
                                              .texts[i]
                                              .content),
                                          const Divider(),
                                          Text(notes[drawer - 1]
                                              .texts[i]
                                              .comment),
                                        ],
                                      ),
                                    ),
                                  )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            );
          },
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

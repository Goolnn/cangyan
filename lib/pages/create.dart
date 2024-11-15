import 'dart:io';

import 'package:cangyan/widgets.dart' as cangyan;
import 'package:cangyan/core.dart' as cangyan;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreatePage extends StatefulWidget {
  final cangyan.CreateState state;

  const CreatePage(this.state, {super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  static const platform = MethodChannel('goolnn.cangyan/intent');

  final controller = TextEditingController();

  final images = <Uint8List>[];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      insetPadding: EdgeInsets.all(
        Platform.isAndroid ? 32.0 : 64.0,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 720.0,
          maxHeight: 540.0,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Center(
                child: Text(
                  '新建项目',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
              const Divider(),
              cangyan.Input(
                placeholder: "标题",
                onChanged: (text) => setState(() {}),
              ),
              const SizedBox(height: 8.0),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blueGrey,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: SingleChildScrollView(
                          child: Wrap(
                            children: [
                              for (int i = 0; i < images.length; i++)
                                FractionallySizedBox(
                                  widthFactor: 1.0 / 3.0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        AspectRatio(
                                          aspectRatio: 3.0 / 4.0,
                                          child: cangyan.Image(
                                            image: images[i],
                                          ),
                                        ),
                                        const SizedBox(height: 4.0),
                                        Text('第${i + 1}页'),
                                      ],
                                    ),
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.all(
                            Platform.isAndroid ? 8.0 : 16.0,
                          ),
                          child: FloatingActionButton.small(
                            shape: const CircleBorder(),
                            onPressed: () async {
                              if (Platform.isAndroid) {
                                final images = (await platform
                                        .invokeListMethod("openImages"))
                                    ?.map((image) => image as Uint8List)
                                    .toList();

                                if (images == null) {
                                  return;
                                }

                                for (final image in images) {
                                  setState(() {
                                    this.images.add(image);
                                  });
                                }
                              } else if (Platform.isWindows) {
                                final result =
                                    await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: ['jpg', 'jpeg', 'png'],
                                  allowMultiple: true,
                                  lockParentWindow: true,
                                );

                                if (result == null) {
                                  return;
                                }

                                final images = await Future.wait(
                                  result.paths.map((path) async {
                                    final file = File(path!);

                                    return await file.readAsBytes();
                                  }),
                                );

                                for (final image in images) {
                                  setState(() {
                                    this.images.add(image);
                                  });
                                }
                              }
                            },
                            child: const Icon(Icons.add),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(),
              Align(
                alignment: Alignment.centerRight,
                child: Wrap(
                  spacing: 8.0,
                  children: [
                    FilledButton.tonal(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: const Text('取消'),
                    ),
                    FilledButton(
                      onPressed: controller.text.isEmpty || images.isEmpty
                          ? null
                          : () {
                              widget.state.create(
                                title: controller.text,
                                images: images,
                              );

                              Navigator.of(context).pop(true);
                            },
                      child: const Text('创建'),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:cangyan/widgets.dart' as cangyan;
import 'package:cangyan/core.dart' as cangyan;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreatePage extends StatefulWidget {
  final cangyan.Workspace workspace;

  const CreatePage(
    this.workspace, {
    super.key,
  });

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  static const platform = MethodChannel('com.goolnn.cangyan/files');

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
                controller: controller,
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
                      SizedBox(
                        width: double.infinity,
                        child: SingleChildScrollView(
                          child: Wrap(
                            children: [
                              for (int i = 0; i < images.length; i++)
                                FractionallySizedBox(
                                  widthFactor: 1 / (Platform.isAndroid ? 3 : 5),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        AspectRatio(
                                          aspectRatio: 3.0 / 4.0,
                                          child: cangyan.Image(
                                            provider: MemoryImage(images[i]),
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
                              final images =
                                  (await platform.invokeListMethod("images"))
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
                    cangyan.Button(
                      '取消',
                      onPressed: () {
                        Navigator.of(context).pop(null);
                      },
                    ),
                    cangyan.Button(
                      '创建',
                      type: cangyan.ButtonType.primary,
                      onPressed: controller.text.isEmpty || images.isEmpty
                          ? null
                          : () {
                              final summary = widget.workspace.create(
                                title: controller.text,
                                images: images,
                              );

                              Navigator.of(context).pop(summary);
                            },
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

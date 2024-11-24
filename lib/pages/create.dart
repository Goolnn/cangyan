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

  final images = <MemoryImage>[];

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
                child: images.isEmpty
                    ? GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          final images = platform.invokeListMethod("images");

                          images.then((images) {
                            if (images == null) {
                              return;
                            }

                            for (final image in images) {
                              setState(() {
                                this.images.add(MemoryImage(image));
                              });
                            }
                          });
                        },
                        child: const Center(
                          child: Icon(
                            Icons.add,
                            size: 32.0,
                          ),
                        ),
                      )
                    : cangyan.ImageViewer(
                        onReorder: (from, to) {
                          setState(() {
                            final image = images.removeAt(from);

                            images.insert(to, image);
                          });
                        },
                        children: [
                          for (int i = 0; i < images.length; i++)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: cangyan.Wave(
                                borderRadius: BorderRadius.circular(8.0),
                                onTapUp: (details) {
                                  HapticFeedback.vibrate();

                                  showMenu<int>(
                                    context: context,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        8.0,
                                      ),
                                    ),
                                    menuPadding: const EdgeInsets.all(4.0),
                                    position: RelativeRect.fromLTRB(
                                      details.globalPosition.dx,
                                      details.globalPosition.dy,
                                      details.globalPosition.dx,
                                      details.globalPosition.dy,
                                    ),
                                    items: [
                                      const PopupMenuItem(
                                        value: 0,
                                        height: 36.0,
                                        child: Text('向前插入新页'),
                                      ),
                                      const PopupMenuItem(
                                        value: 1,
                                        height: 36.0,
                                        child: Text('向后插入新页'),
                                      ),
                                      const PopupMenuDivider(),
                                      const PopupMenuItem(
                                        value: 2,
                                        height: 36.0,
                                        child: Text('删除选择页'),
                                      ),
                                    ],
                                  ).then((value) async {
                                    if (value == 0 || value == 1) {
                                      final images = platform.invokeListMethod(
                                        "images",
                                      );

                                      images.then((images) {
                                        images?.reversed.forEach((image) {
                                          if (image is Uint8List) {
                                            setState(() {
                                              this.images.insert(
                                                    value == 0 ? i : i + 1,
                                                    MemoryImage(image),
                                                  );
                                            });
                                          }
                                        });
                                      });
                                    }

                                    if (value case 2) {
                                      setState(() => images.removeAt(i));
                                    }
                                  });
                                },
                                child: AspectRatio(
                                  aspectRatio: 3.0 / 4.0,
                                  child: cangyan.Image(
                                    provider: images[i],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
              )),
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
                                images: images.map((image) {
                                  return image.bytes;
                                }).toList(),
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

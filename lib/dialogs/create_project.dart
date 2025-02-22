import 'dart:io';

import 'package:cangyan/core.dart' as cangyan;
import 'package:cangyan/dialogs/standard_dialog.dart';
import 'package:cangyan/utils/picker.dart';
import 'package:cangyan/widgets.dart' as cangyan;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateProjectPage extends StatefulWidget {
  final cangyan.Workspace workspace;

  const CreateProjectPage(
    this.workspace, {
    super.key,
  });

  @override
  State<CreateProjectPage> createState() => _CreateProjectPageState();
}

class _CreateProjectPageState extends State<CreateProjectPage> {
  final controller = TextEditingController();

  final images = <MemoryImage>[];

  @override
  Widget build(BuildContext context) {
    return StandardDialog(
      title: '新建项目',
      action: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FilledButton.tonal(
            onPressed: () {
              Navigator.of(context).pop(null);
            },
            child: const Text(
              '取消',
            ),
          ),
          const SizedBox.square(dimension: 8.0),
          FilledButton(
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
            child: const Text('创建'),
          ),
        ],
      ),
      child: Expanded(
        child: Column(
          children: [
            cangyan.Input(
              controller: controller,
              placeholder: "标题",
              onChanged: (text) => setState(() {}),
            ),
            const SizedBox.square(dimension: 8.0),
            Flexible(
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
                          pickImages().then((images) {
                            setState(() {
                              this.images.addAll(images);
                            });
                          });
                        },
                        child: const Center(
                          child: Icon(
                            Icons.add,
                            size: 32.0,
                          ),
                        ),
                      )
                    : Align(
                        alignment: Alignment.topLeft,
                        child: SingleChildScrollView(
                          child: Builder(builder: (context) {
                            final int count;

                            switch (Platform.operatingSystem) {
                              case 'windows':
                                count = 4;
                                break;
                              default:
                                count = 3;
                                break;
                            }

                            return cangyan.ImageViewer(
                              count: count,
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
                                          position: RelativeRect.fromLTRB(
                                            details.globalPosition.dx,
                                            details.globalPosition.dy,
                                            details.globalPosition.dx,
                                            details.globalPosition.dy,
                                          ),
                                          items: [
                                            const cangyan.PopupMenuItem(
                                              value: 0,
                                              child: Text('向前插入新页'),
                                            ),
                                            const cangyan.PopupMenuItem(
                                              value: 1,
                                              child: Text('向后插入新页'),
                                            ),
                                            const cangyan.PopupMenuDivider(),
                                            const cangyan.PopupMenuItem(
                                              value: 2,
                                              child: Text(
                                                '删除选择页',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ).then((value) async {
                                          if (value == 0 || value == 1) {
                                            pickImages().then((images) {
                                              for (var image in images) {
                                                setState(() {
                                                  this.images.insert(
                                                        value == 0 ? i : i + 1,
                                                        image,
                                                      );
                                                });
                                              }
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
                            );
                          }),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cangyan/dialogs/standard_dialog.dart';
import 'package:cangyan/widgets.dart' as cangyan;
import 'package:cangyan/core.dart' as cangyan;
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
  static const platform = MethodChannel('com.goolnn.cangyan/files');

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
      child: Flexible(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: 384.0,
          ),
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
                      : Align(
                          alignment: Alignment.topLeft,
                          child: SingleChildScrollView(
                            child: cangyan.ImageViewer(
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
                                            final images =
                                                platform.invokeListMethod(
                                              "images",
                                            );

                                            images.then((images) {
                                              images?.reversed.forEach((image) {
                                                if (image is Uint8List) {
                                                  setState(() {
                                                    this.images.insert(
                                                          value == 0
                                                              ? i
                                                              : i + 1,
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
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
      // child: SizedBox(
      //   height: 384.0,
      //   child: Column(
      //     children: [
      //       cangyan.Input(
      //         controller: controller,
      //         placeholder: "标题",
      //         onChanged: (text) => setState(() {}),
      //       ),
      //       const SizedBox(height: 8.0),
      //       Expanded(
      //         child: Container(
      //           decoration: BoxDecoration(
      //             border: Border.all(
      //               color: Colors.blueGrey,
      //               width: 1.0,
      //             ),
      //             borderRadius: BorderRadius.circular(8.0),
      //           ),
      //           child: images.isEmpty
      //               ? GestureDetector(
      //                   behavior: HitTestBehavior.translucent,
      //                   onTap: () {
      //                     final images = platform.invokeListMethod("images");

      //                     images.then((images) {
      //                       if (images == null) {
      //                         return;
      //                       }

      //                       for (final image in images) {
      //                         setState(() {
      //                           this.images.add(MemoryImage(image));
      //                         });
      //                       }
      //                     });
      //                   },
      //                   child: const Center(
      //                     child: Icon(
      //                       Icons.add,
      //                       size: 32.0,
      //                     ),
      //                   ),
      //                 )
      //               : Align(
      //                   alignment: Alignment.topLeft,
      //                   child: SingleChildScrollView(
      //                     child: cangyan.ImageViewer(
      //                       onReorder: (from, to) {
      //                         setState(() {
      //                           final image = images.removeAt(from);

      //                           images.insert(to, image);
      //                         });
      //                       },
      //                       children: [
      //                         for (int i = 0; i < images.length; i++)
      //                           Padding(
      //                             padding: const EdgeInsets.all(8.0),
      //                             child: cangyan.Wave(
      //                               borderRadius: BorderRadius.circular(8.0),
      //                               onTapUp: (details) {
      //                                 HapticFeedback.vibrate();

      //                                 showMenu<int>(
      //                                   context: context,
      //                                   position: RelativeRect.fromLTRB(
      //                                     details.globalPosition.dx,
      //                                     details.globalPosition.dy,
      //                                     details.globalPosition.dx,
      //                                     details.globalPosition.dy,
      //                                   ),
      //                                   items: [
      //                                     const cangyan.PopupMenuItem(
      //                                       value: 0,
      //                                       child: Text('向前插入新页'),
      //                                     ),
      //                                     const cangyan.PopupMenuItem(
      //                                       value: 1,
      //                                       child: Text('向后插入新页'),
      //                                     ),
      //                                     const cangyan.PopupMenuDivider(),
      //                                     const cangyan.PopupMenuItem(
      //                                       value: 2,
      //                                       child: Text(
      //                                         '删除选择页',
      //                                         style: TextStyle(
      //                                           color: Colors.red,
      //                                         ),
      //                                       ),
      //                                     ),
      //                                   ],
      //                                 ).then((value) async {
      //                                   if (value == 0 || value == 1) {
      //                                     final images =
      //                                         platform.invokeListMethod(
      //                                       "images",
      //                                     );

      //                                     images.then((images) {
      //                                       images?.reversed.forEach((image) {
      //                                         if (image is Uint8List) {
      //                                           setState(() {
      //                                             this.images.insert(
      //                                                   value == 0 ? i : i + 1,
      //                                                   MemoryImage(image),
      //                                                 );
      //                                           });
      //                                         }
      //                                       });
      //                                     });
      //                                   }

      //                                   if (value case 2) {
      //                                     setState(() => images.removeAt(i));
      //                                   }
      //                                 });
      //                               },
      //                               child: AspectRatio(
      //                                 aspectRatio: 3.0 / 4.0,
      //                                 child: cangyan.Image(
      //                                   provider: images[i],
      //                                 ),
      //                               ),
      //                             ),
      //                           ),
      //                       ],
      //                     ),
      //                   ),
      //                 ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}

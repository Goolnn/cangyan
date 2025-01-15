import 'package:cangyan/cangyan.dart' as cangyan;
import 'package:cangyan/utils/handle.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InfoPage extends StatefulWidget {
  final cangyan.Workspace workspace;
  final Handle handle;
  final cangyan.Pages pages;

  InfoPage({
    super.key,
    required this.workspace,
    required this.handle,
  }) : pages = handle.summary.pages();

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  static const platform = MethodChannel('com.goolnn.cangyan/picker');

  late List<MemoryImage> images;

  late Future<List<MemoryImage>> load;

  @override
  void initState() {
    super.initState();

    load = compute(_loadImages, widget.pages.images());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 256.0 + 64.0,
                child: cangyan.Image(
                  provider: widget.handle.cover,
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        cangyan.Category(widget.handle.category),
                        Expanded(
                          child: cangyan.EditableText(
                            widget.handle.title,
                            onSubmitted: (text) {
                              if (widget.workspace.check(title: text) ||
                                  text == widget.handle.title) {
                                setState(() {
                                  widget.handle.title = text;
                                });
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('工程重名'),
                                      content: const Text('工程名称无法使用重复的内容'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('确定'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ),
                        const cangyan.Progress(0.0),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.handle.comment),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        children: [
                          cangyan.DateText(
                            widget.handle.createdDate,
                            prefix: '创建于',
                            separator: ' ',
                          ),
                          cangyan.DateText(
                            widget.handle.updatedDate,
                            prefix: '更新于',
                            separator: ' ',
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const Divider(),
              FutureBuilder(
                future: load,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 128.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  images = snapshot.data ?? [];

                  return cangyan.ImageViewer(
                    onReorder: (from, to) {
                      widget.pages.movePageTo(
                        from: BigInt.from(from),
                        to: BigInt.from(to),
                      );

                      setState(() {
                        final image = images.removeAt(from);

                        images.insert(to, image);
                      });

                      if (from == 0 || to == 0) {
                        setState(() {
                          widget.handle.cover = images.first;
                        });
                      }
                    },
                    children: [
                      for (int i = 0; i < images.length; i++)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: cangyan.Wave(
                            borderRadius: BorderRadius.circular(8.0),
                            onTap: () => editPage(i),
                            onLongPressStart: (details) {
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
                                  cangyan.PopupMenuItem(
                                    enabled: images.length > 1,
                                    child: Text(
                                      style: TextStyle(
                                        color: images.length > 1
                                            ? Colors.red
                                            : Colors.red.shade300,
                                      ),
                                      '删除选择页',
                                    ),
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('删除页面'),
                                            content: const Text('确定要删除选择页？'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('取消'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);

                                                  widget.pages.removePage(
                                                    index: BigInt.from(i),
                                                  );

                                                  setState(
                                                      () => images.removeAt(i));

                                                  if (i == 0) {
                                                    widget.handle.cover =
                                                        images.first;
                                                  }
                                                },
                                                child: const Text('确定'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ).then((value) async {
                                if (value case 0) {
                                  final images = platform.invokeListMethod(
                                    "images",
                                  );

                                  images.then((images) {
                                    images?.reversed.forEach((value) {
                                      if (value is Uint8List) {
                                        widget.pages.insertPageBefore(
                                          index: BigInt.from(i),
                                          image: value,
                                        );

                                        setState(() => this
                                            .images
                                            .insert(i, MemoryImage(value)));
                                      }
                                    });

                                    if (i == 0) {
                                      widget.handle.cover = this.images.first;
                                    }
                                  });
                                }

                                if (value case 1) {
                                  final images = platform.invokeListMethod(
                                    "images",
                                  );

                                  images.then((images) {
                                    images?.reversed.forEach((value) {
                                      if (value is Uint8List) {
                                        widget.pages.insertPageAfter(
                                          index: BigInt.from(i),
                                          image: value,
                                        );

                                        setState(() => this
                                            .images
                                            .insert(i + 1, MemoryImage(value)));
                                      }
                                    });
                                  });
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
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void editPage(int index) {
    final editor = widget.pages.edit(index: BigInt.from(index));

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return cangyan.Page(
          buttons: [
            cangyan.HeaderButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back,
                size: 16.0,
              ),
            ),
          ],
          child: cangyan.EditPage(
            image: images[index],
            editor: editor,
          ),
        );
      }),
    );
  }
}

List<MemoryImage> _loadImages(List<Uint8List> images) {
  return images.map((image) {
    return MemoryImage(image);
  }).toList();
}

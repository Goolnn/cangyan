import 'dart:io';

import 'package:cangyan/core/cyfile.dart' as cangyan;
import 'package:cangyan/core/states.dart' as cangyan;
import 'package:cangyan/pages/info.dart';
import 'package:cangyan/widgets.dart' as cangyan;
import 'package:cangyan/pages.dart' as cangyan;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class HomePage extends StatefulWidget {
  final cangyan.HomeState state;

  HomePage({
    super.key,
    required String workspace,
  }) : state = cangyan.HomeState(workspace: workspace);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const platform = MethodChannel('goolnn.cangyan/intent');

  @override
  void initState() {
    super.initState();

    platform.setMethodCallHandler((call) async {
      if (call.method == 'newIntent') {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: widget.state.load(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('错误：${snapshot.error}'),
              );
            }

            final summaries = snapshot.data;

            if (summaries == null) {
              return const Center(
                child: Text('没有项目'),
              );
            }

            return ListView.builder(
              itemCount: summaries.length,
              itemBuilder: (context, index) {
                return _Tile(summaries[index], onDelete: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.share),
                            title: const Text('分享'),
                            onTap: () {
                              final filepath = widget.state.filepath(
                                index: BigInt.from(index),
                              );

                              Share.shareXFiles([XFile(filepath)]);

                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.delete),
                            title: const Text('删除'),
                            onTap: () {
                              Navigator.pop(context);

                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('删除项目'),
                                    content: const Text('是否删除项目？'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('取消'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            widget.state.delete(
                                              index: BigInt.from(index),
                                            );
                                          });

                                          Navigator.pop(context);
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
                      );
                    },
                  );
                  // showDialog(
                  //   context: context,
                  //   builder: (context) {
                  //     return AlertDialog(
                  //       title: const Text('删除项目'),
                  //       content: const Text('是否删除项目？'),
                  //       actions: [
                  //         TextButton(
                  //           onPressed: () {
                  //             Navigator.pop(context);
                  //           },
                  //           child: const Text('取消'),
                  //         ),
                  //         TextButton(
                  //           onPressed: () {
                  //             setState(() {
                  //               widget.state.delete(index: BigInt.from(index));
                  //             });

                  //             Navigator.pop(context);
                  //           },
                  //           child: const Text('确定'),
                  //         ),
                  //       ],
                  //     );
                  //   },
                  // );
                });
              },
            );
          },
        ),
      ),
      floatingActionButton: GestureDetector(
        onLongPress: () async {
          if (Platform.isAndroid) {
            await platform.invokeMethod("openIntent");
          } else if (Platform.isWindows) {
            final result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['cy'],
              allowMultiple: true,
              lockParentWindow: true,
            );

            if (result == null) {
              return;
            }

            for (final path in result.paths) {
              final file = File(path!);

              final bytes = await file.readAsBytes();

              final filename = path.split('\\').last;

              final newFile = File(
                  '${(await getApplicationDocumentsDirectory()).path}/cangyan/$filename');

              await newFile.writeAsBytes(bytes);
            }
          }

          setState(() {});
        },
        child: FloatingActionButton(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: const CircleBorder(),
          child: const Icon(Icons.add),
          onPressed: () async {
            await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return cangyan.CreatePage(
                  widget.state.create(),
                );
              },
            ).then((result) {
              if (result == true) {
                setState(() {});
              }
            });
          },
        ),
      ),
    );
  }
}

class _Tile extends StatefulWidget {
  final cangyan.Summary summary;

  final void Function()? onDelete;

  const _Tile(this.summary, {required this.onDelete});

  @override
  State<_Tile> createState() => _TileState();
}

class _TileState extends State<_Tile> {
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return InfoPage(
            summary: widget.summary,
          );
        })).then((result) {
          if (mounted) setState(() {});
        });
      },
      onLongPress: widget.onDelete,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 128.0 + 32.0,
          child: Row(
            children: [
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 3.0 / 4.0,
                    child: cangyan.Image(
                      image: widget.summary.cover(),
                    ),
                  ),
                  Positioned(
                    bottom: 2.0,
                    right: 2.0,
                    child: cangyan.Capsule(
                      child: Text('${widget.summary.pageCount()}页'),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        cangyan.Category(widget.summary.category()),
                        Expanded(
                          child: cangyan.Title(
                            widget.summary.title(),
                            widget.summary.number(),
                          ),
                        ),
                        const cangyan.Progress(0.0),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(widget.summary.comment()),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        children: [
                          Text(
                            '创建于 ${_dateToString(widget.summary.createdDate())}',
                            style: const TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            '更新于 ${_dateToString(widget.summary.updatedDate())}',
                            style: const TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _dateToString(cangyan.Date date) {
    final year = '${date.year}年';
    final month = '${date.month}月';
    final day = '${date.day}日';
    final hour = '${date.hour}'.padLeft(2, '0');
    final minute = '${date.minute}'.padLeft(2, '0');
    final second = '${date.second}'.padLeft(2, '0');

    return '$year$month$day $hour:$minute:$second';
  }
}

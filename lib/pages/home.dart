import 'package:cangyan/core/cyfile.dart' as cangyan;
import 'package:cangyan/core/states.dart' as cangyan;
import 'package:cangyan/pages/info.dart';
import 'package:cangyan/widgets.dart' as cangyan;
import 'package:cangyan/pages.dart' as cangyan;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          await platform.invokeMethod("openIntent");
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

class _Tile extends StatelessWidget {
  final cangyan.Summary summary;

  final void Function()? onDelete;

  const _Tile(this.summary, {required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return InfoPage(
            summary: summary,
          );
        }));
      },
      onLongPress: onDelete,
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
                      image: summary.cover(),
                    ),
                  ),
                  Positioned(
                    bottom: 2.0,
                    right: 2.0,
                    child: cangyan.Capsule(
                      child: Text('${summary.pageCount()}页'),
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
                        cangyan.Category(summary.category()),
                        Expanded(
                          child: cangyan.Title(
                            summary.title(),
                            summary.number(),
                          ),
                        ),
                        const cangyan.Progress(0.0),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(summary.comment()),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        children: [
                          Text(
                            '创建于 ${_dateToString(summary.createdDate())}',
                            style: const TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            '更新于 ${_dateToString(summary.updatedDate())}',
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

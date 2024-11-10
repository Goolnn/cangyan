import 'package:cangyan/core/file.dart' as cangyan;
import 'package:cangyan/core/states.dart' as cangyan;
import 'package:cangyan/pages/info.dart';
import 'package:cangyan/widgets.dart' as cangyan;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const platform = MethodChannel('goolnn.cangyan/intent');

  cangyan.HomeState? state;

  @override
  void initState() {
    super.initState();

    _initState();

    platform.setMethodCallHandler((call) async {
      if (call.method == 'newIntent') {
        setState(() {});
      }
    });
  }

  Future<void> _initState() async {
    final workspace = await getExternalStorageDirectory();

    if (workspace == null) {
      return;
    }

    setState(() {
      state = cangyan.HomeState(workspace: workspace.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (state == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: state?.load(),
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
                              // setState(() {
                              //   summaries[index].delete();
                              // });

                              // Navigator.pop(context);
                            },
                            child: const Text('确定'),
                          ),
                        ],
                      );
                    },
                  );
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
          onPressed: () {},
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
                        // cangyan.Progress(summary.progress()),
                      ],
                    ),
                    const Spacer(),
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

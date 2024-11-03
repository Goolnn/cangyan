import 'dart:io';

import 'package:cangyan/core/api/cyfile/date.dart';
import 'package:cangyan/core/api/cyfile/project.dart';
import 'package:cangyan/core/api/states/home.dart';
import 'package:cangyan/pages/info.dart';
import 'package:cangyan/widgets/widgets.dart' as cangyan;
import 'package:file_picker/file_picker.dart';
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

  HomeState? state;

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
      state = HomeState(workspace: workspace.path);
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
                child: Text('Error: ${snapshot.error}'),
              );
            }

            final projects = state?.projects();

            if (projects == null) {
              return const Center(
                child: Text('No projects'),
              );
            }

            return ListView.builder(
              itemCount: projects.length,
              itemBuilder: (context, index) {
                return _Tile(projects[index], onDelete: () {
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
                                projects[index].delete();
                              });

                              Navigator.pop(context);
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
          FilePickerResult? result = await FilePicker.platform.pickFiles(
            allowMultiple: true,
          );

          if (result == null) {
            return;
          }

          for (final file in result.files) {
            final extension = file.extension;

            if (extension != 'cy') {
              continue;
            }

            final directory = await getExternalStorageDirectory();

            final source = File(file.path!);
            final destination = File('${directory!.path}/${file.name}');

            await source.copy(destination.path);
          }

          setState(() {});
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
  final Project project;

  final void Function()? onDelete;

  const _Tile(this.project, {required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return InfoPage(
            project: project,
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
                      image: project.cover(),
                    ),
                  ),
                  Positioned(
                    bottom: 2.0,
                    right: 2.0,
                    child: cangyan.Capsule('${project.pageCount()}页'),
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
                        cangyan.Category(project.category()),
                        Expanded(
                          child: cangyan.Title(
                            project.title(),
                            project.number(),
                          ),
                        ),
                        cangyan.Progress(project.progress()),
                      ],
                    ),
                    const Spacer(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        children: [
                          Text(
                            '创建于 ${_dateToString(project.createdDate())}',
                            style: const TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            '修改于 ${_dateToString(project.savedDate())}',
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

  String _dateToString(Date date) {
    final year = '${date.year}年';
    final month = '${date.month}月';
    final day = '${date.day}日';
    final hour = '${date.hour}'.padLeft(2, '0');
    final minute = '${date.minute}'.padLeft(2, '0');
    final second = '${date.second}'.padLeft(2, '0');

    return '$year$month$day $hour:$minute:$second';
  }
}

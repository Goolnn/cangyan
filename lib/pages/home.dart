import 'package:cangyan/core/api/cyfile/date.dart';
import 'package:cangyan/core/api/cyfile/project.dart';
import 'package:cangyan/core/api/states/home.dart';
import 'package:cangyan/pages/info.dart';
import 'package:cangyan/widgets/widgets.dart' as cangyan;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeState? state;

  @override
  void initState() {
    super.initState();

    _initState();
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
                return _Tile(projects[index]);
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final Project project;

  const _Tile(this.project);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
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
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return InfoPage(
            project: project,
          );
        }));
      },
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

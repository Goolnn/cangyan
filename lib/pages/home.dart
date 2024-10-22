import 'package:cangyan/core/api/states/home.dart';
import 'package:cangyan/pages/info.dart';
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
          future: state?.summaries(),
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

            final summaries = snapshot.data as List<Summary>;

            return ListView.builder(
              itemCount: summaries.length,
              itemBuilder: (context, index) {
                return Tile(summaries[index]);
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

class Tile extends StatelessWidget {
  final Summary summary;

  const Tile(this.summary, {super.key});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 128.0 + 32.0,
          child: Row(
            children: [
              AspectRatio(
                aspectRatio: 3.0 / 4.0,
                child: Stack(
                  children: [
                    if (summary.cover != null)
                      Center(
                        child: Image.memory(summary.cover!),
                      )
                    else
                      const Placeholder(),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: PageCount(summary.pageCount),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      summary.title,
                      style: const TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          children: [
                            Text(
                              '创建于 ${_dateToString(summary.createdDate)}',
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '修改于 ${_dateToString(summary.savedDate)}',
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        )
                      ],
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
          return const InfoPage();
        }));
      },
    );
  }

  String _dateToString((int, int, int, int, int, int) date) {
    final year = '${date.$1}年';
    final month = '${date.$2}月';
    final day = '${date.$3}日';
    final hour = '${date.$4}'.padLeft(2, '0');
    final minute = '${date.$5}'.padLeft(2, '0');
    final second = '${date.$6}'.padLeft(2, '0');

    return '$year$month$day $hour:$minute:$second';
  }
}

class PageCount extends StatelessWidget {
  final int count;

  const PageCount(this.count, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const StadiumBorder(),
      color: Colors.black.withOpacity(0.15),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 4.0,
        ),
        child: Text(
          '$count页',
          style: const TextStyle(
            fontSize: 13.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

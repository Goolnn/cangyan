import 'package:cangyan/core/api/cyfile/date.dart';
import 'package:cangyan/core/api/cyfile/summary.dart';
import 'package:cangyan/core/api/states/home.dart';
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

            final summaries = state?.summaries();

            if (summaries == null) {
              return const Center(
                child: Text('No summaries'),
              );
            }

            return ListView.builder(
              itemCount: summaries.length,
              itemBuilder: (context, index) {
                return _Tile(summaries[index]);
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
  final Summary summary;

  const _Tile(this.summary);

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
                  cangyan.Image(image: summary.cover()),
                  Positioned(
                    bottom: 2.0,
                    right: 2.0,
                    child: cangyan.Capsule('${summary.pageCount()}页'),
                  ),
                ],
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      summary.title(),
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
                              '创建于 ${_dateToString(summary.createdDate())}',
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '修改于 ${_dateToString(summary.savedDate())}',
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
        // Navigator.push(context, MaterialPageRoute(builder: (context) {
        //   return InfoPage(
        //     summary: summary,
        //   );
        // }));
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

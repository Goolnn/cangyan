import 'dart:io';

import 'package:cangyan/core.dart' as cangyan;
// import 'package:cangyan/pages.dart' as cangyan;
import 'package:cangyan/widgets.dart' as cangyan;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:share_plus/share_plus.dart';

class HomePage extends StatefulWidget {
  final cangyan.HomeState state;

  HomePage({
    super.key,
    required cangyan.Workspace workspace,
  }) : state = cangyan.HomeState(workspace: workspace);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const platform = MethodChannel('goolnn.cangyan/intent');

  late Future<List<(cangyan.Summary, cangyan.Tile)>> load;

  String keyword = '';

  @override
  void initState() {
    super.initState();

    platform.setMethodCallHandler((call) async {
      if (call.method == 'newIntent') {
        setState(() {});
      }
    });

    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: cangyan.SearchBox(
                onChanged: (text) {
                  setState(() {
                    keyword = text;
                  });
                },
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: load,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final tiles = (snapshot.data ?? []).where((element) {
                    return element.$1.title().contains(keyword);
                  }).map((element) {
                    return element.$2;
                  }).toList();

                  return RefreshIndicator(
                    displacement: 12.0,
                    onRefresh: () async {
                      setState(() {
                        refresh();
                      });
                    },
                    child: ListView.builder(
                      itemCount: tiles.length,
                      itemBuilder: (context, index) {
                        return tiles[index];
                      },
                    ),
                  );
                },
              ),
            ),
          ],
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

          setState(() {
            refresh();
          });
        },
        child: FloatingActionButton(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: const CircleBorder(),
          child: const Icon(Icons.add),
          onPressed: () async {
            // await showDialog(
            //   context: context,
            //   barrierDismissible: false,
            //   builder: (context) {
            //     return cangyan.CreatePage(
            //       widget.state.create(),
            //     );
            //   },
            // ).then((result) {
            //   if (result == true) {
            //     setState(() {});
            //   }
            // });
          },
        ),
      ),
    );
  }

  void refresh() {
    load = Future.microtask(() async {
      final summaries = await widget.state.load();

      return summaries.map((summary) {
        return (
          summary,
          cangyan.Tile(
            summary: summary,
            onLongPress: () {
              showModalBottomSheet(
                context: context,
                clipBehavior: Clip.hardEdge,
                builder: (context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.share),
                        title: const Text('分享'),
                        onTap: () {
                          // Share.share(summary.title());
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.delete),
                        title: const Text(
                          '删除',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                        onTap: () async {
                          // summary.delete();

                          setState(() {
                            refresh();
                          });
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        );
      }).toList();
    });
  }
}

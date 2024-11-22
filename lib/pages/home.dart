import 'package:cangyan/cangyan.dart' as cangyan;
import 'package:cangyan/tools/handle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class HomePage extends StatefulWidget {
  final cangyan.Workspace workspace;

  HomePage({
    super.key,
    required String path,
  }) : workspace = cangyan.Workspace(path: path);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const platformMethod = MethodChannel('com.goolnn.cangyan/files');
  static const platformEvent = EventChannel("com.goolnn.cangyan/include");

  late Future<List<cangyan.Summary>> load;

  Map<Handle, cangyan.Tile>? handles;

  String keyword = '';

  @override
  void initState() {
    super.initState();

    load = widget.workspace.load();

    platformEvent
        .receiveBroadcastStream()
        .map((event) => Map<String, dynamic>.from(event as Map))
        .listen((event) {
      final title = event['title'] as String;
      final data = event['data'] as Uint8List;

      widget.workspace.include(title: title, data: data).then(
        (summary) {
          final entry = include(Handle(summary));

          if (entry != null) {
            setState(() {
              handles?.addEntries([entry]);
            });
          }
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: cangyan.SearchBox(
                onChanged: (keyword) {
                  setState(() {
                    this.keyword = keyword;
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

                  handles ??= Map.fromEntries(
                    (snapshot.data ?? []).map(
                      (summary) {
                        return include(Handle(summary))!;
                      },
                    ),
                  );

                  final tiles = handles!.values.where((tile) {
                    return tile.handle.title.contains(keyword);
                  }).toList();

                  return ListView.builder(
                    itemCount: tiles.length,
                    itemBuilder: (context, index) {
                      return tiles[index];
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: GestureDetector(
        onLongPress: () {
          platformMethod.invokeListMethod("projects").then((value) {
            final projects = value?.map(
              (project) {
                return Map<String, dynamic>.from(project as Map);
              },
            ).toList();

            if (projects == null) {
              return;
            }

            for (final project in projects) {
              final title = project['title'] as String;
              final data = project['data'] as Uint8List;

              widget.workspace.include(title: title, data: data).then(
                (summary) {
                  final entry = include(Handle(summary));

                  if (entry != null) {
                    setState(() {
                      handles?.addEntries([entry]);
                    });
                  }
                },
              );
            }
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

  MapEntry<Handle, cangyan.Tile>? include(Handle handle) {
    if (!widget.workspace.check(title: handle.title)) {
      return null;
    }

    return MapEntry(
      handle,
      cangyan.Tile(
        handle: handle,
        onPress: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return cangyan.InfoPage(
                  handle: handle,
                );
              },
            ),
          );
        },
        onLongPress: () {
          showModalBottomSheet(
            clipBehavior: Clip.hardEdge,
            context: context,
            builder: (context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.remove_red_eye,
                    ),
                    title: const Text('查看'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.share,
                    ),
                    title: const Text('分享'),
                    onTap: () {
                      Navigator.pop(context);

                      Share.shareXFiles(
                        [XFile(handle.summary.filepath())],
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.delete,
                    ),
                    title: const Text(
                      '删除',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    onTap: () async {
                      Navigator.pop(context);

                      handle.summary.delete();

                      setState(() {
                        handles!.remove(handle);
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
  }
}

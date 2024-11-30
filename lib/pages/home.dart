import 'package:cangyan/cangyan.dart' as cangyan;
import 'package:cangyan/dialogs/create_project.dart';
import 'package:cangyan/dialogs/duplicated_name.dart';
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

  Map<Handle, Widget>? handles;

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

      if (widget.workspace.check(title: title)) {
        widget.workspace.include(title: title, data: data).then(
          (summary) {
            setState(() {
              handles?.addEntries([include(Handle(summary))]);
            });
          },
        );
      } else {
        duplicated([(title, data)]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 4.0,
              ),
              child: Row(
                children: [
                  Flexible(
                    child: cangyan.SearchBox(
                      onChanged: (keyword) {
                        setState(() {
                          this.keyword = keyword;
                        });
                      },
                    ),
                  ),
                  const SizedBox.square(dimension: 2.0),
                  PopupMenuButton<int>(
                    style: const ButtonStyle(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: WidgetStatePropertyAll(EdgeInsets.all(4.0)),
                      minimumSize: WidgetStatePropertyAll(Size.zero),
                    ),
                    offset: const Offset(0.0, 34.0),
                    constraints: const BoxConstraints(
                      minWidth: 128.0 + 48.0,
                    ),
                    itemBuilder: (context) {
                      return [
                        const cangyan.PopupMenuItem(
                          value: 0,
                          child: Text('设置'),
                        ),
                        const cangyan.PopupMenuItem(
                          value: 1,
                          child: Text('关于'),
                        ),
                      ];
                    },
                    onSelected: (value) {
                      switch (value) {
                        case 0:
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const cangyan.SettingsPage();
                              },
                            ),
                          );
                          break;
                      }
                    },
                  ),
                ],
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
                        return include(Handle(summary));
                      },
                    ),
                  );

                  final tiles = handles!.entries.where((entry) {
                    return entry.key.title.contains(keyword);
                  }).map((entry) {
                    return entry.value;
                  }).toList();

                  return tiles.isEmpty && keyword.isNotEmpty
                      ? const Center(
                          child: Text('无匹配结果'),
                        )
                      : ListView.builder(
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
          HapticFeedback.vibrate();

          platformMethod.invokeListMethod("projects").then((value) {
            final projects = value?.map(
              (project) {
                return Map<String, dynamic>.from(project as Map);
              },
            ).toList();

            if (projects == null) {
              return;
            }

            final List<(String, Uint8List)> pairs = [];

            for (final project in projects) {
              final title = project['title'] as String;
              final data = project['data'] as Uint8List;

              if (widget.workspace.check(title: title)) {
                widget.workspace.include(title: title, data: data).then(
                  (summary) {
                    setState(() {
                      handles?.addEntries([include(Handle(summary))]);
                    });
                  },
                );
              } else {
                pairs.add((title, data));
              }
            }

            if (pairs.isNotEmpty) {
              duplicated(pairs);
            }
          });
        },
        child: FloatingActionButton(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: const CircleBorder(),
          child: const Icon(Icons.add),
          onPressed: () async {
            showDialog<Future<cangyan.Summary>?>(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return CreateProjectPage(
                  widget.workspace,
                );
              },
            ).then((future) {
              future?.then((summary) {
                setState(() {
                  handles?.addEntries([include(Handle(summary))]);
                });
              });
            });
          },
        ),
      ),
    );
  }

  MapEntry<Handle, Widget> include(Handle handle) {
    return MapEntry(
      handle,
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: cangyan.Wave(
          borderRadius: BorderRadius.circular(12.0),
          onTap: () {
            open(handle);
          },
          onLongPress: () {
            HapticFeedback.selectionClick();

            showModalBottomSheet(
              clipBehavior: Clip.hardEdge,
              context: context,
              builder: (context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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

                        showAdaptiveDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('删除'),
                              content: const Text('确定要删除吗？'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('取消'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    handle.summary.delete();

                                    setState(() {
                                      handles!.remove(handle);
                                    });

                                    Navigator.of(context).pop();
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
          },
          child: cangyan.Tile(
            handle: handle,
          ),
        ),
      ),
    );
  }

  void duplicated(List<(String, Uint8List)> pairs) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return DuplicatedNameDialog(
          workspace: widget.workspace,
          pairs: pairs,
        );
      },
    ).then((result) {
      final pairs = result as List<(String, Uint8List)>?;

      if (pairs != null) {
        for (final pair in pairs) {
          widget.workspace.include(title: pair.$1, data: pair.$2).then(
            (summary) {
              if (!widget.workspace.check(title: pair.$1)) {
                handles?.removeWhere((key, value) {
                  return key.title == pair.$1;
                });
              }

              setState(() {
                handles?.addEntries([include(Handle(summary))]);
              });
            },
          );
        }
      }
    });
  }

  void open(Handle handle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return cangyan.InfoPage(
            workspace: widget.workspace,
            handle: handle,
          );
        },
      ),
    );
  }
}

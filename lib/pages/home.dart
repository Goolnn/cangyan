import 'dart:io';

import 'package:cangyan/cangyan.dart' as cangyan;
import 'package:cangyan/dialogs/create_project.dart';
import 'package:cangyan/dialogs/duplicated_name.dart';
import 'package:cangyan/main.dart';
import 'package:cangyan/utils/handle.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:share_plus/share_plus.dart';

class HomePage extends StatefulWidget {
  final cangyan.Workspace workspace;

  final List<String> args;

  HomePage({
    super.key,
    required String path,
    this.args = const [],
  }) : workspace = cangyan.Workspace(path: path);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const platformMethod = MethodChannel('com.goolnn.cangyan/picker');
  static const platformEvent = EventChannel("com.goolnn.cangyan/include");

  late Future<List<cangyan.Summary>> load;

  Map<Handle, Widget>? handles;

  final keyword = ValueNotifier<String>('');

  @override
  void initState() {
    super.initState();

    load = widget.workspace.load();

    switch (Platform.operatingSystem) {
      case "android":
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

        break;
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final List<(String, Uint8List)> pairs = [];

      for (final arg in widget.args) {
        final file = File(arg);

        if (file.existsSync()) {
          final title = path.basenameWithoutExtension(file.path);
          final data = file.readAsBytesSync();

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
      }

      if (pairs.isNotEmpty) {
        duplicated(pairs);
      }
    });

    arguments.stream.listen((args) {
      final List<(String, Uint8List)> pairs = [];

      for (final arg in args) {
        final file = File(arg);

        if (file.existsSync()) {
          final title = path.basenameWithoutExtension(file.path);
          final data = file.readAsBytesSync();

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
      }

      if (pairs.isNotEmpty) {
        duplicated(pairs);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return cangyan.Page(
      buttons: [
        cangyan.HeaderButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const cangyan.AboutPage();
                },
              ),
            );
          },
          child: const Icon(
            Icons.menu,
            size: 16.0,
          ),
        ),
      ],
      header: Builder(builder: (context) {
        final double factor;

        switch (Platform.operatingSystem) {
          case "android":
            factor = 0.75;
            break;
          default:
            factor = 0.6;
            break;
        }

        return Center(
          child: FractionallySizedBox(
            widthFactor: factor,
            child: cangyan.SearchBox(
              onChanged: (keyword) {
                this.keyword.value = keyword;
              },
            ),
          ),
        );
      }),
      child: Scaffold(
        body: DropTarget(
          onDragDone: (details) {
            final List<(String, Uint8List)> pairs = [];

            details.files.map((item) => File(item.path)).forEach((file) {
              if (file.existsSync()) {
                final title = path.basenameWithoutExtension(file.path);
                final data = file.readAsBytesSync();

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
            });

            if (pairs.isNotEmpty) {
              duplicated(pairs);
            }
          },
          child: Column(
            children: [
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: keyword,
                  builder: (context, value, child) {
                    return FutureBuilder(
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
                          return entry.key.title.contains(value);
                        }).map((entry) {
                          return entry.value;
                        }).toList();

                        return tiles.isEmpty && value.isNotEmpty
                            ? const Center(
                                child: Text('无匹配结果'),
                              )
                            : SingleChildScrollView(
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    final width = constraints.maxWidth;
                                    final count = width ~/ 352.0;

                                    return Align(
                                      alignment: Alignment.topLeft,
                                      child: Wrap(
                                        children: tiles.map((tile) {
                                          return SizedBox(
                                            width: width / count,
                                            height: 176.0,
                                            child: tile,
                                          );
                                        }).toList(),
                                      ),
                                    );
                                  },
                                ),
                              );
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
            switch (Platform.operatingSystem) {
              case "android":
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

                break;
            }
          },
          child: FloatingActionButton(
            mini: Platform.isWindows,
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
      ),
    );
  }

  MapEntry<Handle, Widget> include(Handle handle) {
    return MapEntry(
      handle,
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: cangyan.Wave(
          borderRadius: BorderRadius.circular(12.0),
          onTap: () {
            open(handle);
          },
          onLongPress: () {
            HapticFeedback.selectionClick();

            showModalBottomSheet(
              useRootNavigator: true,
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

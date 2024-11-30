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
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: 48.0,
        title: const Text('苍眼'),
        actions: [
          PopupMenuTheme(
            data: PopupMenuThemeData(
              menuPadding: const EdgeInsets.all(4.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              color: Colors.white,
            ),
            child: PopupMenuButton(
              offset: const Offset(0.0, 48.0),
              constraints: const BoxConstraints(
                minWidth: 128.0 + 48.0,
              ),
              itemBuilder: (context) {
                return [
                  const MyPopupMenuItem(
                    value: 0,
                    child: Text('设置'),
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
          ),
        ],
      ),
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
                return cangyan.CreatePage(
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
      cangyan.Wave(
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
                      Icons.remove_red_eye,
                    ),
                    title: const Text('查看'),
                    onTap: () {
                      Navigator.of(context).pop();

                      open(handle);
                    },
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
    );
  }

  void duplicated(List<(String, Uint8List)> pairs) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return cangyan.DuplicatedPage(
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

class TooltipShape extends ShapeBorder {
  const TooltipShape();

  final BorderSide _side = BorderSide.none;
  final BorderRadiusGeometry _borderRadius = BorderRadius.zero;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(_side.width);

  @override
  Path getInnerPath(
    Rect rect, {
    TextDirection? textDirection,
  }) {
    final Path path = Path();

    path.addRRect(
      _borderRadius.resolve(textDirection).toRRect(rect).deflate(_side.width),
    );

    return path;
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final Path path = Path();
    final RRect rrect = _borderRadius.resolve(textDirection).toRRect(rect);

    path.moveTo(0, 10);
    path.quadraticBezierTo(0, 0, 10, 0);
    path.lineTo(rrect.width - 30, 0);
    path.lineTo(rrect.width - 20, -10);
    path.lineTo(rrect.width - 10, 0);
    path.quadraticBezierTo(rrect.width, 0, rrect.width, 10);
    path.lineTo(rrect.width, rrect.height - 10);
    path.quadraticBezierTo(
        rrect.width, rrect.height, rrect.width - 10, rrect.height);
    path.lineTo(10, rrect.height);
    path.quadraticBezierTo(0, rrect.height, 0, rrect.height - 10);

    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => RoundedRectangleBorder(
        side: _side.scale(t),
        borderRadius: _borderRadius * t,
      );
}

class MyPopupMenuItem<T> extends PopupMenuEntry<T> {
  final T value;

  final void Function()? onTap;

  final Widget child;

  const MyPopupMenuItem({
    super.key,
    this.onTap,
    required this.value,
    required this.child,
  });

  @override
  State<StatefulWidget> createState() {
    return _MyPopupMenuItemState();
  }

  @override
  double get height => 32.0;

  @override
  bool represents(T? value) {
    return value == this.value;
  }
}

class _MyPopupMenuItemState<T> extends State<MyPopupMenuItem<T>> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop<T>(context, widget.value);

        widget.onTap?.call();
      },
      borderRadius: BorderRadius.circular(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: widget.child,
      ),
    );
  }
}

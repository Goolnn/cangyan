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

  final searchBoxController = TextEditingController();

  String search = '';

  @override
  void initState() {
    super.initState();

    platform.setMethodCallHandler((call) async {
      if (call.method == 'newIntent') {
        setState(() {});
      }
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
                onChanged: (text) {
                  setState(() {
                    search = text;
                  });
                },
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: widget.state.load(),
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

                  final summaries = (snapshot.data ?? []).map((file) {
                    return cangyan.Summary(file: file);
                  }).toList();

                  if (search.isNotEmpty) {
                    summaries.retainWhere((summary) {
                      return summary.title().contains(search);
                    });
                  }

                  return ListView.builder(
                    itemCount: summaries.length,
                    itemBuilder: (context, index) {
                      return cangyan.Tile(
                        summary: summaries[index],
                        onPress: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) {
                          //       return cangyan.ViewPage(
                          //         widget.state.view(
                          //           index: BigInt.from(index),
                          //         ),
                          //       );
                          //     },
                          //   ),
                          // );
                        },
                        onLongPress: () {
                          showModalBottomSheet(
                            context: context,
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            builder: (context) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.share),
                                    title: const Text('分享'),
                                    onTap: () {
                                      // final filepath = widget.state.filepath(
                                      //   index: BigInt.from(index),
                                      // );

                                      // Share.shareXFiles([XFile(filepath)]);

                                      // Navigator.pop(context);
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
                                    onTap: () {
                                      Navigator.pop(context);

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
                                                  //   widget.state.delete(
                                                  //     index: BigInt.from(index),
                                                  //   );
                                                  // });

                                                  // Navigator.pop(context);
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

          setState(() {});
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
}

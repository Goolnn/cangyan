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

  Map<cangyan.Summary, cangyan.Tile>? tiles;

  String search = '';

  @override
  void initState() {
    super.initState();

    platform.setMethodCallHandler((call) async {
      if (call.method == 'newIntent') {
        setState(() {});
      }
    });

    widget.state.load().then((files) {
      final entries = files.map((file) {
        final summary = cangyan.Summary(
          file: file,
        );

        return MapEntry(
          summary,
          cangyan.Tile(
            summary: summary,
            onPress: () {},
            onLongPress: () {},
          ),
        );
      });

      setState(() {
        tiles = Map.fromEntries(entries);
      });
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
              child: Builder(builder: (context) {
                if (this.tiles == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final tiles = this.tiles!.values.where((tile) {
                  return tile.summary.title().contains(search);
                }).toList();

                return ListView.builder(
                  itemCount: tiles.length,
                  itemBuilder: (context, index) {
                    return tiles[index];
                  },
                );
              }),
              // child: FutureBuilder(
              //   future: widget.state.load(),
              //   builder: (context, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return const Center(
              //         child: CircularProgressIndicator(),
              //       );
              //     }

              //     if (snapshot.hasError) {
              //       return Center(
              //         child: Text('错误：${snapshot.error}'),
              //       );
              //     }

              //     final summaries = (snapshot.data ?? []).map((file) {
              //       return cangyan.Summary(file: file);
              //     }).toList();

              //     if (search.isNotEmpty) {
              //       summaries.where((summary) {
              //         return summary.title().contains(search);
              //       }).toList();
              //     }

              //     return ;
              //   },
              // ),
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

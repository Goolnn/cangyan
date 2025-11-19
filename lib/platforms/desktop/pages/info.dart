import 'dart:math';
import 'dart:typed_data';

import 'package:cangyan/platforms/desktop/pages/edit.dart';
import 'package:cangyan/platforms/desktop/window/button.dart' as window;
import 'package:cangyan/platforms/desktop/window/page.dart' as window;
import 'package:cangyan/src/bindings/bindings.dart' as signals;
import 'package:cangyan/src/bindings/bindings.dart';
import 'package:flutter/material.dart';

class InfoPage extends StatefulWidget {
  final String path;

  final Image cover;

  final String title;
  final String comment;

  final Date createdDate;
  final Date updatedDate;

  final int pageCount;

  const InfoPage({
    super.key,

    required this.path,

    required this.cover,

    required this.title,
    required this.comment,

    required this.createdDate,
    required this.updatedDate,

    required this.pageCount,
  });

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  List<Image>? _images;

  List<Widget>? _pages;

  @override
  void initState() {
    super.initState();

    signals.Open(path: widget.path).sendSignalToRust();
  }

  @override
  Widget build(BuildContext context) {
    return window.Page(
      buttons: [window.WindowBackButton(context)],

      panel: FractionallySizedBox(
        widthFactor: 0.6,
        child: Center(
          child: Text(widget.title, overflow: TextOverflow.ellipsis),
        ),
      ),

      child: Material(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(12.0),

          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  SizedBox(
                    width: 1024.0 + 512.0,
                    height: min(constraints.maxWidth / 2.0, 512.0 + 64.0),

                    child: Row(
                      mainAxisSize: MainAxisSize.max,

                      spacing: 8.0,

                      children: [
                        AspectRatio(
                          aspectRatio: 3.0 / 4.0,

                          child: Center(
                            child: Hero(
                              tag: 'cover_${widget.path}',

                              child: ClipRSuperellipse(
                                borderRadius: BorderRadius.circular(12.0),
                                child: widget.cover,
                              ),
                            ),
                          ),
                        ),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            spacing: 8.0,

                            children: [
                              Expanded(
                                child: widget.comment.isNotEmpty
                                    ? SingleChildScrollView(
                                        padding: const EdgeInsets.only(
                                          right: 12.0,
                                        ),
                                        child: Text(
                                          widget.comment,
                                          style: TextStyle(fontSize: 12.0),
                                        ),
                                      )
                                    : Center(
                                        child: Tooltip(
                                          message: '添加简介',

                                          waitDuration: Duration(
                                            milliseconds: 500,
                                          ),

                                          mouseCursor: SystemMouseCursors.click,

                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,

                                            children: [
                                              Icon(
                                                Icons.edit_note,
                                                size: 128.0,
                                                color: Colors.grey,
                                              ),

                                              Text(
                                                '暂无简介',
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                              ),

                              Align(
                                alignment: Alignment.centerRight,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '创建于 ${widget.createdDate.year}年${widget.createdDate.month}月${widget.createdDate.day}日 ${widget.createdDate.hour}:${widget.createdDate.minute}:${widget.createdDate.second}',
                                      style: TextStyle(
                                        fontSize: 10.0,
                                        color: Colors.grey,
                                      ),
                                    ),

                                    Text(
                                      '修改于 ${widget.updatedDate.year}年${widget.updatedDate.month}月${widget.updatedDate.day}日 ${widget.updatedDate.hour}:${widget.updatedDate.minute}:${widget.updatedDate.second}',
                                      style: TextStyle(
                                        fontSize: 10.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Divider(),

                  StreamBuilder(
                    stream: signals.Pages.rustSignalStream,

                    builder: (context, snapshot) {
                      final data = snapshot.data;
                      final pages = data?.message.value;

                      _images ??= pages?.map((page) {
                        return Image.memory(Uint8List.fromList(page));
                      }).toList();

                      _pages ??= _images?.indexed.map((element) {
                        final index = element.$1 + 1;
                        final image = element.$2;

                        return Column(
                          spacing: 8.0,

                          children: [
                            Flexible(
                              child: AspectRatio(
                                aspectRatio: 3.0 / 4.0,

                                child: Stack(
                                  children: [
                                    Center(
                                      child: Hero(
                                        tag: 'page_${widget.path}_$index',

                                        child: ClipRSuperellipse(
                                          borderRadius: BorderRadius.circular(
                                            12.0,
                                          ),
                                          child: image,
                                        ),
                                      ),
                                    ),

                                    RawMaterialButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          8.0,
                                        ),
                                      ),

                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,

                                      hoverColor: Colors.black.withValues(
                                        alpha: 0.035,
                                      ),
                                      highlightColor: Colors.black.withValues(
                                        alpha: 0.05,
                                      ),
                                      splashColor: Colors.transparent,

                                      onPressed: () async {
                                        await Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return EditPage(
                                                path: widget.path,

                                                page: image,

                                                index: index,
                                              );
                                            },
                                          ),
                                        );
                                      },

                                      child: SizedBox.expand(),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            Text('第$index页'),
                          ],
                        );
                      }).toList();

                      final cardSize = 128.0 + 64.0;
                      final cardAspect = 3.0 / 4.0;

                      final layoutWidth = constraints.maxWidth;

                      final spacing = 16.0;
                      final size = cardSize * cardAspect;

                      final count = min(
                        ((layoutWidth - spacing) / (size + spacing)).toInt(),
                        widget.pageCount,
                      );

                      final width =
                          (layoutWidth - spacing * (count + 1)) / count;
                      final height = size / cardAspect;

                      final aspect = width / height;

                      return GridView.count(
                        shrinkWrap: true,

                        crossAxisCount: count,

                        mainAxisSpacing: spacing,
                        crossAxisSpacing: spacing,

                        padding: EdgeInsets.all(spacing),

                        childAspectRatio: aspect,

                        children:
                            _pages ??
                            List.generate(widget.pageCount, (index) {
                              return Column(
                                spacing: 8.0,

                                children: [
                                  Flexible(
                                    child: AspectRatio(
                                      aspectRatio: 3.0 / 4.0,

                                      child: Center(
                                        child: SizedBox.square(
                                          dimension: 16.0,
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                    ),
                                  ),

                                  Text('第$index页'),
                                ],
                              );
                            }),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

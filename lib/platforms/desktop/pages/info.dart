import 'dart:math';

import 'package:cangyan/platforms/desktop/widgets/page_view.dart' as widgets;
import 'package:cangyan/platforms/desktop/window/button.dart' as window;
import 'package:cangyan/platforms/desktop/window/page.dart' as window;
import 'package:cangyan/src/bindings/bindings.dart' as signals;
import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  final String path;

  final Image cover;

  final String title;
  final String comment;

  final signals.Date createdDate;
  final signals.Date updatedDate;

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
  Widget build(BuildContext context) {
    return window.Page(
      buttons: [window.WindowBackButton(context)],

      panel: FractionallySizedBox(
        widthFactor: 0.6,
        child: Center(
          child: Tooltip(
            message: title,

            waitDuration: Duration(milliseconds: 500),

            child: Text(title, overflow: TextOverflow.ellipsis),
          ),
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
                              tag: 'cover_$path',

                              child: ClipRSuperellipse(
                                borderRadius: BorderRadius.circular(12.0),

                                child: cover,
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
                                child: comment.isNotEmpty
                                    ? SingleChildScrollView(
                                        padding: const EdgeInsets.only(
                                          right: 12.0,
                                        ),
                                        child: Text(
                                          comment,
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
                                      '创建于 ${createdDate.year}年${createdDate.month}月${createdDate.day}日 ${createdDate.hour}:${createdDate.minute}:${createdDate.second}',
                                      style: TextStyle(
                                        fontSize: 10.0,
                                        color: Colors.grey,
                                      ),
                                    ),

                                    Text(
                                      '修改于 ${updatedDate.year}年${updatedDate.month}月${updatedDate.day}日 ${updatedDate.hour}:${updatedDate.minute}:${updatedDate.second}',
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

                  widgets.PageView(path: path, pageCount: pageCount),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

import 'dart:typed_data';

import 'package:cangyan/platforms/desktop/pages/info.dart' as pages;
import 'package:cangyan/platforms/desktop/widgets/capsule_card.dart' as widgets;
import 'package:cangyan/src/bindings/signals/signals.dart';
import 'package:flutter/material.dart';

class ProjectCard extends StatelessWidget {
  final String path;

  final Image cover;

  final String title;
  final String comment;

  final Date createdDate;
  final Date updatedDate;

  final int pageCount;

  const ProjectCard({
    super.key,

    required this.path,

    required this.cover,

    required this.title,
    required this.comment,

    required this.createdDate,
    required this.updatedDate,

    required this.pageCount,
  });

  ProjectCard.overview(Overview overview, {super.key, required this.path})
    : cover = Image.memory(Uint8List.fromList(overview.cover)),
      title = overview.title,
      comment = overview.comment,
      createdDate = overview.createdDate,
      updatedDate = overview.updatedDate,
      pageCount = overview.pageCount;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),

          child: Row(
            spacing: 12.0,

            children: [
              AspectRatio(
                aspectRatio: 3.0 / 4.0,

                child: Stack(
                  children: [
                    Center(
                      child: Hero(
                        tag: 'cover_$title',
                        child: ClipRSuperellipse(
                          borderRadius: BorderRadius.circular(12.0),
                          child: cover,
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 2.0,
                      right: 2.0,

                      child: widgets.CapsuleCard(child: Text('$pageCount页')),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  spacing: 4.0,

                  children: [
                    Text(title, overflow: TextOverflow.ellipsis),

                    Expanded(
                      child: Text(comment, style: TextStyle(fontSize: 12.0)),
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

        RawMaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),

          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,

          hoverColor: Colors.black.withValues(alpha: 0.035),
          highlightColor: Colors.black.withValues(alpha: 0.05),
          splashColor: Colors.transparent,

          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return pages.InfoPage(
                    path: path,

                    cover: cover,

                    title: title,
                    comment: comment,

                    createdDate: createdDate,
                    updatedDate: updatedDate,

                    pageCount: pageCount,
                  );
                },
              ),
            );
          },

          child: SizedBox.expand(),
        ),
      ],
    );
  }
}

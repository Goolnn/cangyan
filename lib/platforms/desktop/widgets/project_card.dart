import 'dart:typed_data';

import 'package:animations/animations.dart';
import 'package:cangyan/platforms/desktop/pages/info.dart' as pages;
import 'package:cangyan/platforms/desktop/widgets/capsule_card.dart' as widgets;
import 'package:cangyan/src/bindings/signals/signals.dart' as signals;
import 'package:flutter/material.dart';

class ProjectCard extends StatefulWidget {
  final String path;

  final Image cover;

  final String title;
  final String comment;

  final signals.Date createdDate;
  final signals.Date updatedDate;

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

  ProjectCard.overview(
    signals.Overview overview, {
    super.key,
    required this.path,
  }) : cover = Image.memory(Uint8List.fromList(overview.cover)),
       title = overview.title,
       comment = overview.comment,
       createdDate = overview.createdDate,
       updatedDate = overview.updatedDate,
       pageCount = overview.pageCount;

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
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
                        tag: 'cover_${widget.path}',
                        child: ClipRSuperellipse(
                          borderRadius: BorderRadius.circular(12.0),
                          child: widget.cover,
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 2.0,
                      right: 2.0,

                      child: widgets.CapsuleCard(
                        child: Text('${widget.pageCount}页'),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  spacing: 4.0,

                  children: [
                    Text(widget.title, overflow: TextOverflow.ellipsis),

                    Expanded(
                      child: Text(
                        widget.comment,
                        style: TextStyle(fontSize: 12.0),
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

        GestureDetector(
          onSecondaryTapUp: (details) async {
            final width = 256.0;
            final height = 256.0 + 128.0;

            final position = details.globalPosition;

            double paddingLeft = position.dx;
            double paddingTop = position.dy;

            double paddingRight =
                MediaQuery.of(context).size.width - position.dx - width;

            if (paddingRight < 0) {
              paddingLeft += paddingRight;
              paddingRight = 0;
            }

            double paddingBottom =
                MediaQuery.of(context).size.height - position.dy - height;

            if (paddingBottom < 0) {
              paddingTop += paddingBottom;
              paddingBottom = 0;
            }

            await showModal(
              context: context,

              configuration: FadeScaleTransitionConfiguration(
                barrierColor: Colors.transparent,
              ),

              builder: (context) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(
                    paddingLeft,
                    paddingTop,
                    paddingRight,
                    paddingBottom,
                  ),

                  child: Card(),
                );
              },
            );
          },

          child: RawMaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),

            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,

            hoverColor: Colors.black.withValues(alpha: 0.035),
            highlightColor: Colors.black.withValues(alpha: 0.05),
            splashColor: Colors.transparent,

            focusColor: Colors.black.withValues(alpha: 0.035),

            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return pages.InfoPage(
                      path: widget.path,

                      cover: widget.cover,

                      title: widget.title,
                      comment: widget.comment,

                      createdDate: widget.createdDate,
                      updatedDate: widget.updatedDate,

                      pageCount: widget.pageCount,
                    );
                  },
                ),
              );
            },

            child: SizedBox.expand(
              // child: Container(
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(8.0),
              //     color: Colors.black.withValues(alpha: _focus ? 0.045 : 0),
              //   ),
              // ),
            ),
          ),
        ),
      ],
    );
  }
}

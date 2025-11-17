import 'dart:math';

import 'package:cangyan/platforms/desktop/widgets/project_card.dart' as widgets;
import 'package:cangyan/src/bindings/bindings.dart' as signals;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

enum ViewMode { list, grid }

class ProjectView extends StatefulWidget {
  final ViewMode viewMode;

  final double cardAspect;
  final double cardSize;

  final String? searchText;

  const ProjectView({
    super.key,

    this.viewMode = ViewMode.grid,

    this.cardAspect = 2.0 / 1.0,
    this.cardSize = 128.0 + 32.0 + 16.0,

    this.searchText,
  });

  @override
  State<ProjectView> createState() => _ProjectViewState();
}

class _ProjectViewState extends State<ProjectView> {
  List<widgets.ProjectCard>? cards;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: signals.Overviews.rustSignalStream,

      builder: (context, snapshot) {
        final data = snapshot.data;

        if (data == null) {
          return Center(child: CircularProgressIndicator());
        }

        if (cards == null) {
          final overviews = data.message.value;

          cards = overviews.map((overview) {
            final cover = Image.memory(Uint8List.fromList(overview.cover));

            final title = overview.title;
            final comment = overview.comment;

            final createdDate = overview.createdDate;
            final updatedDate = overview.updatedDate;

            final pageCount = overview.pageCount;

            return widgets.ProjectCard(
              cover: cover,

              title: title,
              comment: comment,

              createdDate: createdDate,
              updatedDate: updatedDate,

              pageCount: pageCount,
            );
          }).toList();
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final layoutWidth = constraints.maxWidth;

            final spacing = 12.0;
            final size = widget.cardSize * widget.cardAspect;

            final int count;

            switch (widget.viewMode) {
              case ViewMode.list:
                count = 1;
              case ViewMode.grid:
                count = min(
                  ((layoutWidth - spacing) / (size + spacing)).toInt(),
                  this.cards?.length ?? 0,
                );
            }

            if (count == 0) {
              return _EmptyView();
            }

            final width = (layoutWidth - spacing * (count + 1)) / count;
            final height = size / widget.cardAspect;

            final aspect = width / height;

            final cards = (this.cards ?? []).where((card) {
              final searchText = widget.searchText;

              if (searchText == null || searchText.isEmpty) {
                return true;
              }

              final title = card.title.toLowerCase();
              final comment = card.comment.toLowerCase();

              final query = searchText.toLowerCase();

              return title.contains(query) || comment.contains(query);
            }).toList();

            if (cards.isEmpty) {
              return _NotFoundView();
            }

            return _DoubleTapDetector(
              onDoubleTap: () {
                // TODO: 双击背景导入工程
              },

              child: GridView.count(
                crossAxisCount: count,

                mainAxisSpacing: spacing,
                crossAxisSpacing: spacing,

                padding: EdgeInsets.all(spacing),

                childAspectRatio: aspect,

                children: cards,
              ),
            );
          },
        );
      },
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return _IconView(MdiIcons.packageVariant, message: '暂无项目');
  }
}

class _NotFoundView extends StatelessWidget {
  const _NotFoundView();

  @override
  Widget build(BuildContext context) {
    return _IconView(Icons.search, message: '无搜索结果');
  }
}

class _IconView extends StatelessWidget {
  final IconData? icon;

  final String message;

  const _IconView(this.icon, {required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Icon(
            icon,
            size: 128.0 + 64.0,
            color: Colors.black.withValues(alpha: 0.1),
          ),

          Text(
            message,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.black.withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    );
  }
}

class _DoubleTapDetector extends StatefulWidget {
  final void Function() onDoubleTap;

  final Widget child;

  const _DoubleTapDetector({required this.onDoubleTap, required this.child});

  @override
  State<_DoubleTapDetector> createState() => _DoubleTapDetectorState();
}

class _DoubleTapDetectorState extends State<_DoubleTapDetector> {
  static const _doubleTapThreshold = Duration(milliseconds: 300);

  DateTime? _lastTapTime;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,

      onTap: () {
        if (_lastTapTime == null) {
          _lastTapTime = DateTime.now();

          return;
        }

        final nowTapTime = DateTime.now();

        final difference = nowTapTime.difference(_lastTapTime!);

        if (difference <= _doubleTapThreshold) {
          widget.onDoubleTap.call();

          _lastTapTime = null;
        } else {
          _lastTapTime = nowTapTime;
        }
      },

      child: widget.child,
    );
  }
}

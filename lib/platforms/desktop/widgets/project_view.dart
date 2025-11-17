import 'package:cangyan/platforms/desktop/widgets/project_card.dart' as widgets;
import 'package:flutter/material.dart';

class ProjectView extends StatelessWidget {
  final ViewMode viewMode;

  final double cardAspect;
  final double cardSize;

  const ProjectView({
    super.key,

    this.viewMode = ViewMode.grid,

    this.cardAspect = 2.0 / 1.0,
    this.cardSize = 128.0 + 32.0 + 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final layoutWidth = constraints.maxWidth;

        final spacing = 12.0;
        final size = cardSize * cardAspect;

        final int count;

        switch (viewMode) {
          case ViewMode.list:
            count = 1;
          case ViewMode.grid:
            count = ((layoutWidth - spacing) / (size + spacing)).toInt();
        }

        final width = (layoutWidth - spacing * (count + 1)) / count;
        final height = size / cardAspect;

        final aspect = width / height;

        return GridView.count(
          crossAxisCount: count,

          mainAxisSpacing: spacing,
          crossAxisSpacing: spacing,

          padding: EdgeInsets.all(spacing),

          childAspectRatio: aspect,

          children: [for (int i = 0; i < 32; i++) widgets.ProjectCard()],
        );
      },
    );
  }
}

enum ViewMode { list, grid }

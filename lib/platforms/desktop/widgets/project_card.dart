import 'package:cangyan/platforms/desktop/widgets/capsule_card.dart' as widgets;
import 'package:flutter/material.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({super.key});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),

      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,

      onPressed: () {},

      child: Padding(
        padding: const EdgeInsets.all(12.0),

        child: Row(
          spacing: 12.0,

          children: [
            AspectRatio(
              aspectRatio: 3.0 / 4.0,

              child: Stack(
                children: [
                  Placeholder(),

                  Positioned(
                    bottom: 2.0,
                    right: 2.0,

                    child: widgets.CapsuleCard(child: Text('页数')),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                spacing: 2.0,

                children: [
                  Text('标题', style: TextStyle(fontSize: 16.0)),

                  Expanded(child: Text('标题' * 64)),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      children: [
                        Text(
                          '创建于',
                          style: TextStyle(fontSize: 12.0, color: Colors.grey),
                        ),
                        Text(
                          '修改于',
                          style: TextStyle(fontSize: 12.0, color: Colors.grey),
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
    );
  }
}

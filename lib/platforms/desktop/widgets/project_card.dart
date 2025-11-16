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
            AspectRatio(aspectRatio: 3.0 / 4.0, child: Placeholder()),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('标题', style: TextStyle(fontSize: 16.0)),
                  Expanded(
                    child: Text(
                      '标题' * 64,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
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

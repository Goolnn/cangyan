import 'package:cangyan/cangyan.dart' as cangyan;
import 'package:cangyan/tools/handle.dart';
import 'package:flutter/material.dart';

class Tile extends StatefulWidget {
  final Handle handle;

  const Tile({
    super.key,
    required this.handle,
  });

  @override
  State<Tile> createState() => _TileState();
}

class _TileState extends State<Tile> {
  @override
  void initState() {
    super.initState();

    widget.handle.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 128.0 + 32.0,
        child: Row(
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 3.0 / 4.0,
                  child: cangyan.Image(
                    provider: widget.handle.cover,
                  ),
                ),
                Positioned(
                  bottom: 2.0,
                  right: 2.0,
                  child: cangyan.Capsule(
                    child: Text('${widget.handle.pageCount}页'),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      cangyan.Category(widget.handle.category),
                      Expanded(
                        child: cangyan.Title(
                          widget.handle.title,
                          widget.handle.number,
                        ),
                      ),
                      cangyan.Progress(widget.handle.progress),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        widget.handle.comment,
                        style: const TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      children: [
                        cangyan.DateText(
                          widget.handle.createdDate,
                          prefix: '创建于',
                          separator: ' ',
                        ),
                        cangyan.DateText(
                          widget.handle.updatedDate,
                          prefix: '更新于',
                          separator: ' ',
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

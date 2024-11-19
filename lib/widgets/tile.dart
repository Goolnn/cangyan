import 'package:cangyan/core.dart' as cangyan;
import 'package:cangyan/widgets.dart' as cangyan;
import 'package:flutter/material.dart';

class Tile extends StatefulWidget {
  final MemoryImage cover;

  final cangyan.Summary summary;

  final Function()? onPress;
  final Function()? onLongPress;

  Tile({
    super.key,
    required this.summary,
    this.onPress,
    this.onLongPress,
  }) : cover = MemoryImage(summary.cover());

  @override
  State<Tile> createState() => _TileState();
}

class _TileState extends State<Tile> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
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
                        provider: widget.cover,
                      ),
                    ),
                    Positioned(
                      bottom: 2.0,
                      right: 2.0,
                      child: cangyan.Capsule(
                        child: Text('${widget.summary.pageCount()}页'),
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
                          cangyan.Category(widget.summary.category()),
                          Expanded(
                            child: cangyan.Title(
                              widget.summary.title(),
                              widget.summary.number(),
                            ),
                          ),
                          const cangyan.Progress(0.0),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(widget.summary.comment()),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Column(
                          children: [
                            Text(
                              '创建于 ${dateToString(widget.summary.createdDate())}',
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '更新于 ${dateToString(widget.summary.updatedDate())}',
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey,
                              ),
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
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: Colors.black.withOpacity(0.08),
              highlightColor: Colors.black.withOpacity(0.08),
              onTap: widget.onPress,
              onLongPress: widget.onLongPress,
            ),
          ),
        ),
      ],
    );
  }

  String dateToString(cangyan.Date date) {
    final year = '${date.year}年';
    final month = '${date.month}月';
    final day = '${date.day}日';
    final hour = '${date.hour}'.padLeft(2, '0');
    final minute = '${date.minute}'.padLeft(2, '0');
    final second = '${date.second}'.padLeft(2, '0');

    return '$year$month$day $hour:$minute:$second';
  }
}

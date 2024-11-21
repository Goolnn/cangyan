import 'package:cangyan/cangyan.dart' as cangyan;
import 'package:flutter/material.dart';

class Tile extends StatefulWidget {
  final TileController controller;

  final cangyan.Summary summary;

  final Function()? onPress;
  final Function()? onLongPress;

  Tile({
    super.key,
    required this.summary,
    this.onPress,
    this.onLongPress,
  }) : controller = TileController(summary);

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
                        provider: widget.controller.cover,
                      ),
                    ),
                    Positioned(
                      bottom: 2.0,
                      right: 2.0,
                      child: cangyan.Capsule(
                        child: Text('${widget.controller.pageCount}页'),
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
                          cangyan.Category(widget.controller.category),
                          Expanded(
                            child: cangyan.Title(
                              widget.controller.title,
                              widget.controller.number,
                            ),
                          ),
                          cangyan.Progress(widget.controller.progress),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(widget.controller.comment),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Column(
                          children: [
                            Text(
                              '创建于 ${dateToString(widget.controller.createdDate)}',
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '更新于 ${dateToString(widget.controller.updatedDate)}',
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

class TileController extends ChangeNotifier {
  final cangyan.Summary summary;

  late MemoryImage cover;
  late int pageCount;

  late String category;
  late String title;
  late (int, int) number;
  late double progress;

  late String comment;

  late cangyan.Date createdDate;
  late cangyan.Date updatedDate;

  TileController(this.summary) {
    cover = MemoryImage(summary.cover());
    pageCount = summary.pageCount().toInt();

    category = summary.category();
    title = summary.title();
    number = summary.number();
    progress = summary.progress();

    comment = summary.comment();

    createdDate = summary.createdDate();
    updatedDate = summary.updatedDate();
  }
}

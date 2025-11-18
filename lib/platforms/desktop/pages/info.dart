import 'package:cangyan/platforms/desktop/window/button.dart' as window;
import 'package:cangyan/platforms/desktop/window/page.dart' as window;
import 'package:cangyan/src/bindings/bindings.dart';
import 'package:flutter/material.dart';

class InfoPage extends StatefulWidget {
  final String path;

  final Image cover;

  final String title;
  final String comment;

  final Date createdDate;
  final Date updatedDate;

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
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    return window.Page(
      buttons: [window.WindowBackButton(context)],

      panel: FractionallySizedBox(
        widthFactor: 0.6,
        child: Center(
          child: Text(widget.title, overflow: TextOverflow.ellipsis),
        ),
      ),

      child: Material(
        child: Center(
          child: Hero(
            tag: 'cover_${widget.title}',
            child: ClipRSuperellipse(
              borderRadius: BorderRadius.circular(12.0),
              child: widget.cover,
            ),
          ),
        ),
      ),
    );
  }
}

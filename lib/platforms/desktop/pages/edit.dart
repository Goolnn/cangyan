import 'package:cangyan/platforms/desktop/window/button.dart' as window;
import 'package:cangyan/platforms/desktop/window/page.dart' as widgets;
import 'package:flutter/material.dart';

class EditPage extends StatelessWidget {
  final String path;

  final Widget page;

  final int index;

  const EditPage({
    super.key,

    required this.path,

    required this.page,

    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return widgets.Page(
      buttons: [window.WindowBackButton(context)],

      child: Material(
        child: Center(
          child: Hero(
            tag: 'page_${path}_$index',

            child: ClipRSuperellipse(
              borderRadius: BorderRadius.circular(12.0),
              child: page,
            ),
          ),
        ),
      ),
    );
  }
}

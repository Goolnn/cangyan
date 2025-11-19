import 'package:cangyan/l10n/app_localizations.dart';
import 'package:cangyan/platforms/desktop/window/button.dart' as window;
import 'package:cangyan/platforms/desktop/window/page.dart' as window;
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EditPage extends StatefulWidget {
  final String path;

  final List<Image> images;

  final int initialIndex;

  const EditPage({
    super.key,

    required this.path,

    required this.images,

    required this.initialIndex,
  });

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late PageController _controller;

  late int _currentIndex;

  @override
  void initState() {
    super.initState();

    _controller = PageController(initialPage: widget.initialIndex);

    _currentIndex = widget.initialIndex;
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return window.Page(
      buttons: [window.WindowBackButton(context)],

      panel: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,

          spacing: 8.0,

          children: [
            Tooltip(
              message: AppLocalizations.of(context)!.previousPage,

              waitDuration: Duration(milliseconds: 500),

              child: window.WindowButton(
                onPressed: _currentIndex > 0 ? () => _switchPage(-1) : null,

                child: Icon(MdiIcons.chevronLeft),
              ),
            ),

            Text('第${_currentIndex + 1}页'),

            Tooltip(
              message: AppLocalizations.of(context)!.nextPage,

              waitDuration: Duration(milliseconds: 500),

              child: window.WindowButton(
                onPressed: _currentIndex < widget.images.length - 1
                    ? () => _switchPage(1)
                    : null,

                child: Icon(MdiIcons.chevronRight),
              ),
            ),
          ],
        ),
      ),

      child: Material(
        child: Stack(
          children: [
            PageView.builder(
              controller: _controller,

              itemCount: widget.images.length,

              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },

              itemBuilder: (context, index) {
                return Center(
                  child: Hero(
                    tag: 'page_${widget.path}_$index',

                    child: ClipRSuperellipse(
                      borderRadius: BorderRadius.circular(12.0),

                      child: widget.images[index],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _switchPage(int offset) {
    int targetPage = _currentIndex + offset;

    if (targetPage >= 0 && targetPage < widget.images.length) {
      _controller.animateToPage(
        targetPage,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    }
  }
}

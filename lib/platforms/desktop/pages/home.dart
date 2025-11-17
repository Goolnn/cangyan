import 'package:cangyan/l10n/app_localizations.dart';
import 'package:cangyan/platforms/desktop/pages/about.dart';
import 'package:cangyan/platforms/desktop/widgets/drop_icon.dart';
import 'package:cangyan/platforms/desktop/widgets/project_view.dart' as widgets;
import 'package:cangyan/platforms/desktop/widgets/search_box.dart' as widgets;
import 'package:cangyan/platforms/desktop/window/button.dart' as window;
import 'package:cangyan/platforms/desktop/window/frame.dart' as window;
import 'package:cangyan/platforms/desktop/window/page.dart' as window;
import 'package:cangyan/src/bindings/bindings.dart' as signals;
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _droppable = true;

  String _searchText = "";

  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: _searchText);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(const AssetImage("assets/logo.png"), context);
    });
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return window.Page(
      dropping: _droppable
          ? Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                children: [
                  DropIcon(
                    onDragDone: (details) {
                      final paths = details.files.map((item) {
                        return item.path;
                      }).toList();

                      signals.Move(value: paths).sendSignalToRust();
                    },

                    icon: Icons.file_upload_outlined,

                    size: 128.0,
                    color: Colors.white,

                    child: Text(
                      AppLocalizations.of(context)!.dropMove,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                  DropIcon(
                    onDragDone: (details) {
                      final paths = details.files.map((item) {
                        return item.path;
                      }).toList();

                      signals.Copy(value: paths).sendSignalToRust();
                    },

                    icon: Icons.copy_outlined,

                    size: 128.0,
                    color: Colors.white,

                    child: Text(
                      AppLocalizations.of(context)!.dropCopy,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            )
          : null,

      panel: Center(
        child: FractionallySizedBox(
          widthFactor: 0.5,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: widgets.SearchBox(
              controller: _controller,

              onChanged: (text) {
                setState(() {
                  _searchText = text;
                });
              },
            ),
          ),
        ),
      ),

      buttons: [
        Tooltip(
          message: AppLocalizations.of(context)!.homeAboutButton,

          waitDuration: Duration(milliseconds: 500),

          child: window.WindowButton(
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => AboutPage()));
            },
            child: Icon(Icons.menu, size: window.kWindowTitleBarSize * 0.4),
          ),
        ),
      ],

      child: Scaffold(
        body: widgets.ProjectView(searchText: _searchText),

        floatingActionButton: Tooltip(
          message: "新建工程",

          waitDuration: Duration(milliseconds: 500),

          child: FloatingActionButton.small(
            backgroundColor: Colors.lightBlue,
            foregroundColor: Colors.white,

            shape: OvalBorder(),

            onPressed: () async {
              setState(() {
                _droppable = false;
              });

              // TODO: Show new file dialog

              setState(() {
                _droppable = true;
              });
            },
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}

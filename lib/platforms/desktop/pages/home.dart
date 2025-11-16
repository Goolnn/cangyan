import 'package:cangyan/l10n/app_localizations.dart';
import 'package:cangyan/platforms/desktop/pages/about.dart';
import 'package:cangyan/platforms/desktop/widgets/drop_icon.dart';
import 'package:cangyan/platforms/desktop/window/button.dart' as window;
import 'package:cangyan/platforms/desktop/window/frame.dart' as window;
import 'package:cangyan/platforms/desktop/window/page.dart' as window;
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _droppable = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(const AssetImage("assets/logo.png"), context);
    });
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
                      // TODO: Done move
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
                      // TODO: Done copy
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
        body: Placeholder(),

        floatingActionButton: FloatingActionButton.small(
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
    );
  }
}

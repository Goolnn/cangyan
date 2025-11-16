import 'package:cangyan/l10n/app_localizations.dart';
import 'package:cangyan/platforms/desktop/window/button.dart' as window;
import 'package:cangyan/platforms/desktop/window/page.dart' as window;
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return window.Page(
      buttons: [window.WindowBackButton(context: context)],

      panel: Center(child: Text(AppLocalizations.of(context)!.aboutTitle)),

      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 6.0,
            children: [
              SizedBox.square(
                dimension: 128.0,
                child: ClipRSuperellipse(
                  borderRadius: BorderRadiusGeometry.all(Radius.circular(32.0)),
                  child: Image(image: AssetImage("assets/logo.png")),
                ),
              ),
              Column(
                children: [
                  Text('苍眼', style: TextStyle(fontSize: 24.0)),
                  Text('0.4.0'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

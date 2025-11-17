import 'package:cangyan/l10n/app_localizations.dart';
import 'package:cangyan/platforms/desktop/window/button.dart' as window;
import 'package:cangyan/platforms/desktop/window/page.dart' as window;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
                  Tooltip(
                    message: '访问项目主页',

                    waitDuration: Duration(milliseconds: 500),

                    child: Text.rich(
                      TextSpan(
                        text: '苍眼',
                        style: const TextStyle(fontSize: 24.0),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            final url = Uri.parse(
                              'https://github.com/Goolnn/cangyan',
                            );

                            await launchUrl(
                              url,
                              mode: LaunchMode.externalApplication,
                            );
                          },
                      ),
                    ),
                  ),

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

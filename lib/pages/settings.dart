import 'package:cangyan/core/api/update.dart';
import 'package:cangyan/dialogs/new_version.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool checkUpdate = true;

  bool fetching = false;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: CheckUpdateButton(),
        ),
      ),
    );
  }
}

class CheckUpdateButton extends StatefulWidget {
  const CheckUpdateButton({super.key});

  @override
  State<CheckUpdateButton> createState() => _CheckUpdateButtonState();
}

class _CheckUpdateButtonState extends State<CheckUpdateButton> {
  bool fetching = false;
  bool latested = false;

  bool downloading = false;
  double progress = 0.0;

  String? version;

  Future<bool?> showNewVersionDialog(
    String currentVersion,
    String latestVersion,
    DateTime published,
    Asset asset,
  ) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return NewVersionDialog(
          currentVersion: currentVersion,
          latestVersion: latestVersion,
          published: published,
          asset: asset,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      onPressed: fetching || latested
          ? null
          : () {
              if (fetching) {
                return;
              }

              setState(() {
                fetching = true;
              });

              Update.fetch().then((release) async {
                final info = await PackageInfo.fromPlatform();
                final version = 'v${info.version}';

                if (release.checkUpdate(version: version)) {
                  Asset? asset = release.assetOf(platform: Platform.android);

                  if (asset == null) {
                    setState(() {
                      fetching = false;
                      latested = true;
                    });
                  } else {
                    final currentVersion = version;
                    final latestVersion = release.version;

                    final dateTime = release.published;
                    final published = DateTime.parse(dateTime).toLocal();

                    showNewVersionDialog(
                      currentVersion,
                      latestVersion,
                      published,
                      asset,
                    ).then((value) {
                      setState(() {
                        fetching = false;
                        latested = false;
                      });
                    });
                  }
                } else {
                  setState(() {
                    fetching = false;
                    latested = true;
                  });
                }
              });
            },
      child: fetching
          ? const SizedBox.square(
              dimension: 20.0,
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : Text(latested ? '已是最新版本' : '检查更新'),
    );
  }
}

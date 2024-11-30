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
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                setState(() {
                  checkUpdate = !checkUpdate;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text('自动检查最新版本'),
                  ),
                  Checkbox(
                    value: checkUpdate,
                    onChanged: (value) {
                      setState(() {
                        checkUpdate = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
            const Center(
              child: CheckUpdateButton(),
              // child: FilledButton(
              //   onPressed: () {
              //     if (fetching) {
              //       return;
              //     }

              //     setState(() {
              //       fetching = true;
              //     });

              //     Update.fetch().then((release) async {
              //       final info = await PackageInfo.fromPlatform();
              //       final version = 'v${info.version}';

              //       if (release.checkUpdate(version: version)) {
              //         print('New version available');
              //       } else {
              //         print('No new version available');
              //       }

              //       setState(() {
              //         fetching = false;
              //       });
              //     });
              //   },
              //   child: fetching
              //       ? const SizedBox.square(
              //           dimension: 20.0,
              //           child: CircularProgressIndicator(
              //             color: Colors.white,
              //           ),
              //         )
              //       : const Text('检查更新'),
              // ),
            )
          ],
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
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
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
                  Asset? asset;

                  try {
                    asset = release.assets.firstWhere((asset) {
                      return asset.name.contains('android');
                    });
                  } catch (e) {
                    asset = null;
                  }

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

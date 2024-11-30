import 'dart:io';

import 'package:app_installer/app_installer.dart';
import 'package:cangyan/core/api/update.dart';
import 'package:cangyan/dialogs/standard_dialog.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class NewVersionDialog extends StatefulWidget {
  final String currentVersion;
  final String latestVersion;

  final DateTime published;

  final Asset asset;

  const NewVersionDialog({
    super.key,
    required this.currentVersion,
    required this.latestVersion,
    required this.published,
    required this.asset,
  });

  @override
  State<NewVersionDialog> createState() => _NewVersionDialogState();
}

class _NewVersionDialogState extends State<NewVersionDialog> {
  static bool downloading = false;

  double progress = 0.0;

  File? file;

  @override
  Widget build(BuildContext context) {
    final currentVersion = widget.currentVersion;
    final latestVersion = widget.latestVersion;

    return StandardDialog(
      title: '发现新版本',
      action: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (!downloading && progress == 0.0) ...[
            FilledButton.tonal(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('忽略'),
            ),
            const SizedBox.square(
              dimension: 8.0,
            ),
            FilledButton(
              onPressed: () async {
                setState(() {
                  downloading = true;
                  progress = 0.0;
                });

                final cache = (await getExternalCacheDirectories())![0];
                final path = '${cache.path}/${widget.asset.name}';

                file = File(path);

                if (file!.existsSync()) {
                  setState(() {
                    downloading = false;
                    progress = 1.0;
                  });

                  return;
                }

                widget.asset.download().listen(
                  (event) {
                    file?.writeAsBytesSync(
                      event,
                      mode: FileMode.append,
                    );

                    setState(() {
                      progress += event.length / widget.asset.size;
                    });
                  },
                  onDone: () {
                    setState(() {
                      downloading = false;
                      progress = 1.0;
                    });
                  },
                );
              },
              child: const Text('下载'),
            ),
          ] else if (progress == 1.0) ...[
            FilledButton.tonal(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('取消'),
            ),
            const SizedBox.square(
              dimension: 8.0,
            ),
            FilledButton(
              onPressed: () {
                AppInstaller.installApk(file!.path);
                Navigator.pop(context);
              },
              child: const Text('安装'),
            )
          ] else
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 18.0,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: LinearProgressIndicator(
                    value: progress,
                  ),
                ),
              ),
            ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(currentVersion),
            ),
            const Icon(Icons.arrow_right_alt),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(latestVersion),
            ),
          ],
        ),
      ),
    );
  }
}

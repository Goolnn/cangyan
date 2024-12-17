import 'dart:io';

import 'package:path_provider/path_provider.dart';

String application() {
  return 'lib';
}

Future<String> workspace() async {
  if (Platform.isAndroid) {
    return getExternalStorageDirectory().then((directory) {
      return directory!.path;
    });
  } else {
    return getApplicationDocumentsDirectory().then((directory) {
      final path = "${directory.path}\\cangyan";

      Directory(path).createSync(recursive: true);

      return path;
    });
  }
}

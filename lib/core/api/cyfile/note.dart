// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.5.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'text.dart';

// These function are ignored because they are on traits that is not defined in current crate (put an empty `#[frb]` on it to unignore): `clone`, `from`, `from`

class Note {
  double x;
  double y;
  Text? comfirm;
  List<Text> texts;

  Note({
    required this.x,
    required this.y,
    this.comfirm,
    required this.texts,
  });

  @override
  int get hashCode =>
      x.hashCode ^ y.hashCode ^ comfirm.hashCode ^ texts.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Note &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y &&
          comfirm == other.comfirm &&
          texts == other.texts;
}

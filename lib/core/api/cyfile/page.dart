// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.5.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../../frb_generated.dart';
import 'note.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'text.dart';

// These function are ignored because they are on traits that is not defined in current crate (put an empty `#[frb]` on it to unignore): `clone`, `from`, `from`

class Page {
  final Uint8List data;
  final List<Note> notes;

  const Page({
    required this.data,
    required this.notes,
  });

  @override
  int get hashCode => data.hashCode ^ notes.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Page &&
          runtimeType == other.runtimeType &&
          data == other.data &&
          notes == other.notes;
}

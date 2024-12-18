// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.5.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../../frb_generated.dart';
import '../cyfile/note.dart';
import '../cyfile/text.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<Arc < Mutex < File > >>>
abstract class ArcMutexFile implements RustOpaqueInterface {}

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<Editor>>
abstract class Editor implements RustOpaqueInterface {
  void appendNote({required double x, required double y});

  factory Editor({required ArcMutexFile file, required BigInt index}) =>
      RustLib.instance.api
          .crateApiToolsEditorEditorNew(file: file, index: index);

  List<Note> notes();

  void removeNote({required BigInt index});

  void setNoteNumber({required BigInt index, required BigInt number});

  void updateNoteComment({required BigInt index, required String comment});

  void updateNoteContent({required BigInt index, required String content});

  void updateNotePosition(
      {required BigInt index, required double x, required double y});
}

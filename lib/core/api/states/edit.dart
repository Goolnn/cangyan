// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.5.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../../frb_generated.dart';
import '../cyfile/note.dart';
import '../cyfile/page.dart';
import '../cyfile/text.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<Arc < Mutex < File > >>>
abstract class ArcMutexFile implements RustOpaqueInterface {}

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<EditState>>
abstract class EditState implements RustOpaqueInterface {
  factory EditState({required ArcMutexFile file, required BigInt pageIndex}) =>
      RustLib.instance.api
          .crateApiStatesEditEditStateNew(file: file, pageIndex: pageIndex);

  Page? page();

  void setPage({required Page page});
}

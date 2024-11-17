// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.5.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../../frb_generated.dart';
import '../cyfile/date.dart';
import '../states/home.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<Summary>>
abstract class Summary implements RustOpaqueInterface {
  String category();

  String comment();

  Uint8List cover();

  Date createdDate();

  factory Summary({required ArcMutexFile file}) =>
      RustLib.instance.api.crateApiToolsSummarySummaryNew(file: file);

  (int, int) number();

  BigInt pageCount();

  String title();

  Date updatedDate();
}
// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.5.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../../frb_generated.dart';
import 'home.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<InfoState>>
abstract class InfoState implements RustOpaqueInterface {
  String category();

  Uint8List? cover();

  (int, int, int, int, int, int) createdDate();

  factory InfoState({required ArcFile file}) =>
      RustLib.instance.api.crateApiStatesInfoInfoStateNew(file: file);

  (int, int) number();

  int pageCount();

  List<Uint8List> pages();

  (int, int, int, int, int, int) savedDate();

  String title();
}
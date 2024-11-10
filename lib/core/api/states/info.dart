// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.5.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../../frb_generated.dart';
import '../cyfile/credit.dart';
import '../cyfile/summary.dart';
import 'edit.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<InfoState>>
abstract class InfoState implements RustOpaqueInterface {
  static InfoState from({required Summary summary}) =>
      RustLib.instance.api.crateApiStatesInfoInfoStateFrom(summary: summary);

  factory InfoState({required ArcMutexFile file}) =>
      RustLib.instance.api.crateApiStatesInfoInfoStateNew(file: file);

  EditState openPage({required BigInt index});

  void setCategory({required String category});

  void setComment({required String comment});

  void setCover({required List<int> cover});

  void setCredits({required Map<Credit, Set<String>> credits});

  void setNumber({required (int, int) number});

  void setTitle({required String title});

  Summary summary();
}

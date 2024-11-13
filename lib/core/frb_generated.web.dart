// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.5.0.

// ignore_for_file: unused_import, unused_element, unnecessary_import, duplicate_ignore, invalid_use_of_internal_member, annotate_overrides, non_constant_identifier_names, curly_braces_in_flow_control_structures, prefer_const_literals_to_create_immutables, unused_field

// Static analysis wrongly picks the IO variant, thus ignore this
// ignore_for_file: argument_type_not_assignable

import 'api/cyfile/credit.dart';
import 'api/cyfile/date.dart';
import 'api/cyfile/note.dart';
import 'api/cyfile/page.dart';
import 'api/cyfile/summary.dart';
import 'api/cyfile/text.dart';
import 'api/states/create.dart';
import 'api/states/edit.dart';
import 'api/states/home.dart';
import 'api/states/info.dart';
import 'dart:async';
import 'dart:convert';
import 'frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated_web.dart';

abstract class RustLibApiImplPlatform extends BaseApiImpl<RustLibWire> {
  RustLibApiImplPlatform({
    required super.handler,
    required super.wire,
    required super.generalizedFrbRustBinding,
    required super.portManager,
  });

  CrossPlatformFinalizerArg
      get rust_arc_decrement_strong_count_ArcMutexFilePtr => wire
          .rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerArcMutexFile;

  CrossPlatformFinalizerArg
      get rust_arc_decrement_strong_count_CreateStatePtr => wire
          .rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerCreateState;

  CrossPlatformFinalizerArg get rust_arc_decrement_strong_count_EditStatePtr =>
      wire.rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerEditState;

  CrossPlatformFinalizerArg get rust_arc_decrement_strong_count_HomeStatePtr =>
      wire.rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerHomeState;

  CrossPlatformFinalizerArg get rust_arc_decrement_strong_count_InfoStatePtr =>
      wire.rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerInfoState;

  CrossPlatformFinalizerArg get rust_arc_decrement_strong_count_SummaryPtr => wire
      .rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSummary;

  @protected
  AnyhowException dco_decode_AnyhowException(dynamic raw);

  @protected
  ArcMutexFile
      dco_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerArcMutexFile(
          dynamic raw);

  @protected
  CreateState
      dco_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerCreateState(
          dynamic raw);

  @protected
  EditState
      dco_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerEditState(
          dynamic raw);

  @protected
  HomeState
      dco_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerHomeState(
          dynamic raw);

  @protected
  InfoState
      dco_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerInfoState(
          dynamic raw);

  @protected
  Summary
      dco_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSummary(
          dynamic raw);

  @protected
  HomeState
      dco_decode_Auto_RefMut_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerHomeState(
          dynamic raw);

  @protected
  CreateState
      dco_decode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerCreateState(
          dynamic raw);

  @protected
  EditState
      dco_decode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerEditState(
          dynamic raw);

  @protected
  HomeState
      dco_decode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerHomeState(
          dynamic raw);

  @protected
  InfoState
      dco_decode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerInfoState(
          dynamic raw);

  @protected
  Summary
      dco_decode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSummary(
          dynamic raw);

  @protected
  Map<Credit, Set<String>> dco_decode_Map_credit_Set_String(dynamic raw);

  @protected
  ArcMutexFile
      dco_decode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerArcMutexFile(
          dynamic raw);

  @protected
  CreateState
      dco_decode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerCreateState(
          dynamic raw);

  @protected
  EditState
      dco_decode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerEditState(
          dynamic raw);

  @protected
  HomeState
      dco_decode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerHomeState(
          dynamic raw);

  @protected
  InfoState
      dco_decode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerInfoState(
          dynamic raw);

  @protected
  Summary
      dco_decode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSummary(
          dynamic raw);

  @protected
  Set<String> dco_decode_Set_String(dynamic raw);

  @protected
  String dco_decode_String(dynamic raw);

  @protected
  Page dco_decode_box_autoadd_page(dynamic raw);

  @protected
  (int, int) dco_decode_box_autoadd_record_u_32_u_32(dynamic raw);

  @protected
  Credit dco_decode_credit(dynamic raw);

  @protected
  Date dco_decode_date(dynamic raw);

  @protected
  double dco_decode_f_64(dynamic raw);

  @protected
  int dco_decode_i_32(dynamic raw);

  @protected
  List<Summary>
      dco_decode_list_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSummary(
          dynamic raw);

  @protected
  List<String> dco_decode_list_String(dynamic raw);

  @protected
  List<Uint8List> dco_decode_list_list_prim_u_8_strict(dynamic raw);

  @protected
  List<Note> dco_decode_list_note(dynamic raw);

  @protected
  List<int> dco_decode_list_prim_u_8_loose(dynamic raw);

  @protected
  Uint8List dco_decode_list_prim_u_8_strict(dynamic raw);

  @protected
  List<(Credit, Set<String>)> dco_decode_list_record_credit_set_string(
      dynamic raw);

  @protected
  List<Text> dco_decode_list_text(dynamic raw);

  @protected
  Note dco_decode_note(dynamic raw);

  @protected
  Page? dco_decode_opt_box_autoadd_page(dynamic raw);

  @protected
  Page dco_decode_page(dynamic raw);

  @protected
  (Credit, Set<String>) dco_decode_record_credit_set_string(dynamic raw);

  @protected
  (int, int) dco_decode_record_u_32_u_32(dynamic raw);

  @protected
  Text dco_decode_text(dynamic raw);

  @protected
  int dco_decode_u_16(dynamic raw);

  @protected
  int dco_decode_u_32(dynamic raw);

  @protected
  int dco_decode_u_8(dynamic raw);

  @protected
  void dco_decode_unit(dynamic raw);

  @protected
  BigInt dco_decode_usize(dynamic raw);

  @protected
  AnyhowException sse_decode_AnyhowException(SseDeserializer deserializer);

  @protected
  ArcMutexFile
      sse_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerArcMutexFile(
          SseDeserializer deserializer);

  @protected
  CreateState
      sse_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerCreateState(
          SseDeserializer deserializer);

  @protected
  EditState
      sse_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerEditState(
          SseDeserializer deserializer);

  @protected
  HomeState
      sse_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerHomeState(
          SseDeserializer deserializer);

  @protected
  InfoState
      sse_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerInfoState(
          SseDeserializer deserializer);

  @protected
  Summary
      sse_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSummary(
          SseDeserializer deserializer);

  @protected
  HomeState
      sse_decode_Auto_RefMut_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerHomeState(
          SseDeserializer deserializer);

  @protected
  CreateState
      sse_decode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerCreateState(
          SseDeserializer deserializer);

  @protected
  EditState
      sse_decode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerEditState(
          SseDeserializer deserializer);

  @protected
  HomeState
      sse_decode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerHomeState(
          SseDeserializer deserializer);

  @protected
  InfoState
      sse_decode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerInfoState(
          SseDeserializer deserializer);

  @protected
  Summary
      sse_decode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSummary(
          SseDeserializer deserializer);

  @protected
  Map<Credit, Set<String>> sse_decode_Map_credit_Set_String(
      SseDeserializer deserializer);

  @protected
  ArcMutexFile
      sse_decode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerArcMutexFile(
          SseDeserializer deserializer);

  @protected
  CreateState
      sse_decode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerCreateState(
          SseDeserializer deserializer);

  @protected
  EditState
      sse_decode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerEditState(
          SseDeserializer deserializer);

  @protected
  HomeState
      sse_decode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerHomeState(
          SseDeserializer deserializer);

  @protected
  InfoState
      sse_decode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerInfoState(
          SseDeserializer deserializer);

  @protected
  Summary
      sse_decode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSummary(
          SseDeserializer deserializer);

  @protected
  Set<String> sse_decode_Set_String(SseDeserializer deserializer);

  @protected
  String sse_decode_String(SseDeserializer deserializer);

  @protected
  Page sse_decode_box_autoadd_page(SseDeserializer deserializer);

  @protected
  (int, int) sse_decode_box_autoadd_record_u_32_u_32(
      SseDeserializer deserializer);

  @protected
  Credit sse_decode_credit(SseDeserializer deserializer);

  @protected
  Date sse_decode_date(SseDeserializer deserializer);

  @protected
  double sse_decode_f_64(SseDeserializer deserializer);

  @protected
  int sse_decode_i_32(SseDeserializer deserializer);

  @protected
  List<Summary>
      sse_decode_list_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSummary(
          SseDeserializer deserializer);

  @protected
  List<String> sse_decode_list_String(SseDeserializer deserializer);

  @protected
  List<Uint8List> sse_decode_list_list_prim_u_8_strict(
      SseDeserializer deserializer);

  @protected
  List<Note> sse_decode_list_note(SseDeserializer deserializer);

  @protected
  List<int> sse_decode_list_prim_u_8_loose(SseDeserializer deserializer);

  @protected
  Uint8List sse_decode_list_prim_u_8_strict(SseDeserializer deserializer);

  @protected
  List<(Credit, Set<String>)> sse_decode_list_record_credit_set_string(
      SseDeserializer deserializer);

  @protected
  List<Text> sse_decode_list_text(SseDeserializer deserializer);

  @protected
  Note sse_decode_note(SseDeserializer deserializer);

  @protected
  Page? sse_decode_opt_box_autoadd_page(SseDeserializer deserializer);

  @protected
  Page sse_decode_page(SseDeserializer deserializer);

  @protected
  (Credit, Set<String>) sse_decode_record_credit_set_string(
      SseDeserializer deserializer);

  @protected
  (int, int) sse_decode_record_u_32_u_32(SseDeserializer deserializer);

  @protected
  Text sse_decode_text(SseDeserializer deserializer);

  @protected
  int sse_decode_u_16(SseDeserializer deserializer);

  @protected
  int sse_decode_u_32(SseDeserializer deserializer);

  @protected
  int sse_decode_u_8(SseDeserializer deserializer);

  @protected
  void sse_decode_unit(SseDeserializer deserializer);

  @protected
  BigInt sse_decode_usize(SseDeserializer deserializer);

  @protected
  bool sse_decode_bool(SseDeserializer deserializer);

  @protected
  void sse_encode_AnyhowException(
      AnyhowException self, SseSerializer serializer);

  @protected
  void
      sse_encode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerArcMutexFile(
          ArcMutexFile self, SseSerializer serializer);

  @protected
  void
      sse_encode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerCreateState(
          CreateState self, SseSerializer serializer);

  @protected
  void
      sse_encode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerEditState(
          EditState self, SseSerializer serializer);

  @protected
  void
      sse_encode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerHomeState(
          HomeState self, SseSerializer serializer);

  @protected
  void
      sse_encode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerInfoState(
          InfoState self, SseSerializer serializer);

  @protected
  void
      sse_encode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSummary(
          Summary self, SseSerializer serializer);

  @protected
  void
      sse_encode_Auto_RefMut_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerHomeState(
          HomeState self, SseSerializer serializer);

  @protected
  void
      sse_encode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerCreateState(
          CreateState self, SseSerializer serializer);

  @protected
  void
      sse_encode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerEditState(
          EditState self, SseSerializer serializer);

  @protected
  void
      sse_encode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerHomeState(
          HomeState self, SseSerializer serializer);

  @protected
  void
      sse_encode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerInfoState(
          InfoState self, SseSerializer serializer);

  @protected
  void
      sse_encode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSummary(
          Summary self, SseSerializer serializer);

  @protected
  void sse_encode_Map_credit_Set_String(
      Map<Credit, Set<String>> self, SseSerializer serializer);

  @protected
  void
      sse_encode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerArcMutexFile(
          ArcMutexFile self, SseSerializer serializer);

  @protected
  void
      sse_encode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerCreateState(
          CreateState self, SseSerializer serializer);

  @protected
  void
      sse_encode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerEditState(
          EditState self, SseSerializer serializer);

  @protected
  void
      sse_encode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerHomeState(
          HomeState self, SseSerializer serializer);

  @protected
  void
      sse_encode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerInfoState(
          InfoState self, SseSerializer serializer);

  @protected
  void
      sse_encode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSummary(
          Summary self, SseSerializer serializer);

  @protected
  void sse_encode_Set_String(Set<String> self, SseSerializer serializer);

  @protected
  void sse_encode_String(String self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_page(Page self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_record_u_32_u_32(
      (int, int) self, SseSerializer serializer);

  @protected
  void sse_encode_credit(Credit self, SseSerializer serializer);

  @protected
  void sse_encode_date(Date self, SseSerializer serializer);

  @protected
  void sse_encode_f_64(double self, SseSerializer serializer);

  @protected
  void sse_encode_i_32(int self, SseSerializer serializer);

  @protected
  void
      sse_encode_list_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSummary(
          List<Summary> self, SseSerializer serializer);

  @protected
  void sse_encode_list_String(List<String> self, SseSerializer serializer);

  @protected
  void sse_encode_list_list_prim_u_8_strict(
      List<Uint8List> self, SseSerializer serializer);

  @protected
  void sse_encode_list_note(List<Note> self, SseSerializer serializer);

  @protected
  void sse_encode_list_prim_u_8_loose(List<int> self, SseSerializer serializer);

  @protected
  void sse_encode_list_prim_u_8_strict(
      Uint8List self, SseSerializer serializer);

  @protected
  void sse_encode_list_record_credit_set_string(
      List<(Credit, Set<String>)> self, SseSerializer serializer);

  @protected
  void sse_encode_list_text(List<Text> self, SseSerializer serializer);

  @protected
  void sse_encode_note(Note self, SseSerializer serializer);

  @protected
  void sse_encode_opt_box_autoadd_page(Page? self, SseSerializer serializer);

  @protected
  void sse_encode_page(Page self, SseSerializer serializer);

  @protected
  void sse_encode_record_credit_set_string(
      (Credit, Set<String>) self, SseSerializer serializer);

  @protected
  void sse_encode_record_u_32_u_32((int, int) self, SseSerializer serializer);

  @protected
  void sse_encode_text(Text self, SseSerializer serializer);

  @protected
  void sse_encode_u_16(int self, SseSerializer serializer);

  @protected
  void sse_encode_u_32(int self, SseSerializer serializer);

  @protected
  void sse_encode_u_8(int self, SseSerializer serializer);

  @protected
  void sse_encode_unit(void self, SseSerializer serializer);

  @protected
  void sse_encode_usize(BigInt self, SseSerializer serializer);

  @protected
  void sse_encode_bool(bool self, SseSerializer serializer);
}

// Section: wire_class

class RustLibWire implements BaseWire {
  RustLibWire.fromExternalLibrary(ExternalLibrary lib);

  void rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerArcMutexFile(
          int ptr) =>
      wasmModule
          .rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerArcMutexFile(
              ptr);

  void rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerArcMutexFile(
          int ptr) =>
      wasmModule
          .rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerArcMutexFile(
              ptr);

  void rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerCreateState(
          int ptr) =>
      wasmModule
          .rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerCreateState(
              ptr);

  void rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerCreateState(
          int ptr) =>
      wasmModule
          .rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerCreateState(
              ptr);

  void rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerEditState(
          int ptr) =>
      wasmModule
          .rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerEditState(
              ptr);

  void rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerEditState(
          int ptr) =>
      wasmModule
          .rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerEditState(
              ptr);

  void rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerHomeState(
          int ptr) =>
      wasmModule
          .rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerHomeState(
              ptr);

  void rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerHomeState(
          int ptr) =>
      wasmModule
          .rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerHomeState(
              ptr);

  void rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerInfoState(
          int ptr) =>
      wasmModule
          .rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerInfoState(
              ptr);

  void rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerInfoState(
          int ptr) =>
      wasmModule
          .rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerInfoState(
              ptr);

  void rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSummary(
          int ptr) =>
      wasmModule
          .rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSummary(
              ptr);

  void rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSummary(
          int ptr) =>
      wasmModule
          .rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSummary(
              ptr);
}

@JS('wasm_bindgen')
external RustLibWasmModule get wasmModule;

@JS()
@anonymous
extension type RustLibWasmModule._(JSObject _) implements JSObject {
  external void
      rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerArcMutexFile(
          int ptr);

  external void
      rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerArcMutexFile(
          int ptr);

  external void
      rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerCreateState(
          int ptr);

  external void
      rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerCreateState(
          int ptr);

  external void
      rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerEditState(
          int ptr);

  external void
      rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerEditState(
          int ptr);

  external void
      rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerHomeState(
          int ptr);

  external void
      rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerHomeState(
          int ptr);

  external void
      rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerInfoState(
          int ptr);

  external void
      rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerInfoState(
          int ptr);

  external void
      rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSummary(
          int ptr);

  external void
      rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSummary(
          int ptr);
}

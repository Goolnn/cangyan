// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.5.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

// These function are ignored because they are on traits that is not defined in current crate (put an empty `#[frb]` on it to unignore): `clone`, `fmt`, `fmt`

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<Update>>
abstract class Update implements RustOpaqueInterface {
  static Future<Release> fetch() =>
      RustLib.instance.api.crateApiUpdateUpdateFetch();
}

class Asset {
  final String name;
  final int size;
  final String url;

  const Asset({
    required this.name,
    required this.size,
    required this.url,
  });

  @override
  int get hashCode => name.hashCode ^ size.hashCode ^ url.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Asset &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          size == other.size &&
          url == other.url;
}

enum Platform {
  windows,
  android,
  ;
}

class Release {
  final String version;
  final String published;
  final bool prerelease;
  final List<Asset> assets;

  const Release({
    required this.version,
    required this.published,
    required this.prerelease,
    required this.assets,
  });

  Asset? assetOf({required Platform platform}) => RustLib.instance.api
      .crateApiUpdateReleaseAssetOf(that: this, platform: platform);

  bool checkUpdate({required String version}) => RustLib.instance.api
      .crateApiUpdateReleaseCheckUpdate(that: this, version: version);

  @override
  int get hashCode =>
      version.hashCode ^
      published.hashCode ^
      prerelease.hashCode ^
      assets.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Release &&
          runtimeType == other.runtimeType &&
          version == other.version &&
          published == other.published &&
          prerelease == other.prerelease &&
          assets == other.assets;
}

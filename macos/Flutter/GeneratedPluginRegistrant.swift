//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import app_installer
import bitsdojo_window_macos
import package_info_plus
import path_provider_foundation
import screen_retriever_macos
import share_plus
import window_manager

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  AppInstallerPlugin.register(with: registry.registrar(forPlugin: "AppInstallerPlugin"))
  BitsdojoWindowPlugin.register(with: registry.registrar(forPlugin: "BitsdojoWindowPlugin"))
  FPPPackageInfoPlusPlugin.register(with: registry.registrar(forPlugin: "FPPPackageInfoPlusPlugin"))
  PathProviderPlugin.register(with: registry.registrar(forPlugin: "PathProviderPlugin"))
  ScreenRetrieverMacosPlugin.register(with: registry.registrar(forPlugin: "ScreenRetrieverMacosPlugin"))
  SharePlusMacosPlugin.register(with: registry.registrar(forPlugin: "SharePlusMacosPlugin"))
  WindowManagerPlugin.register(with: registry.registrar(forPlugin: "WindowManagerPlugin"))
}

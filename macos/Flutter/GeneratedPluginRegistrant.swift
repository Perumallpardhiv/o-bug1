//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import audioplayers_darwin
import path_provider_macos
import record_macos
import shared_preferences_macos
import wakelock_macos
import zego_express_engine
import zego_zim

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  AudioplayersDarwinPlugin.register(with: registry.registrar(forPlugin: "AudioplayersDarwinPlugin"))
  PathProviderPlugin.register(with: registry.registrar(forPlugin: "PathProviderPlugin"))
  RecordMacosPlugin.register(with: registry.registrar(forPlugin: "RecordMacosPlugin"))
  SharedPreferencesPlugin.register(with: registry.registrar(forPlugin: "SharedPreferencesPlugin"))
  WakelockMacosPlugin.register(with: registry.registrar(forPlugin: "WakelockMacosPlugin"))
  ZegoExpressEnginePlugin.register(with: registry.registrar(forPlugin: "ZegoExpressEnginePlugin"))
  ZegoZimPlugin.register(with: registry.registrar(forPlugin: "ZegoZimPlugin"))
}

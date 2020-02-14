import Flutter
import UIKit

public class SwiftBackgroundImageGallerySaverPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "background_image_gallery_saver", binaryMessenger: registrar.messenger())
    let instance = SwiftBackgroundImageGallerySaverPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}

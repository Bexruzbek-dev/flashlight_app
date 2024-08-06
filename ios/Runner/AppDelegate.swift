import UIKit
import Flutter
import AVFoundation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  private let channelName = "flashlight"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let flashlightChannel = FlutterMethodChannel(name: channelName, binaryMessenger: controller.binaryMessenger)

    flashlightChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if call.method == "toggleFlashlight" {
        if let args = call.arguments as? [String: Any], let isOn = args["isOn"] as? Bool {
          self.toggleFlashlight(isOn: isOn)
          result(nil)
        } else {
          result(FlutterError(code: "INVALID_ARGUMENT", message: "Invalid argument", details: nil))
        }
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func toggleFlashlight(isOn: Bool) {
    guard let device = AVCaptureDevice.default(for: AVMediaType.video), device.hasTorch else {
      return
    }

    do {
      try device.lockForConfiguration()
      device.torchMode = isOn ? .on : .off
      device.unlockForConfiguration()
    } catch {
      print("Torch could not be used")
    }
  }
}

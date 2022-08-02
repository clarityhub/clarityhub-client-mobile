import UIKit
import Flutter
import flutter_auth0

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    setenv("CFNETWORK_DIAGNOSTICS", "3", 1);

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    setenv("CFNETWORK_DIAGNOSTICS", "3", 1);
    return FlutterAuth0Plugin.application(app, open: url, options: options)
  }
}

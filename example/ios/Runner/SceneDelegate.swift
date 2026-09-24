import FreshchatSDK
import Flutter
import UIKit

class SceneDelegate: FlutterSceneDelegate {
  override func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let windowScene = scene as? UIWindowScene else { return }
    let viewController = window?.rootViewController as? FlutterViewController
    
    window = FreshchatSdkPluginWindow(windowScene: windowScene)
    window?.rootViewController = viewController
    window?.makeKeyAndVisible()
  }
}


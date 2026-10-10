# **Freshchat Flutter SDK (BETA)**
[**Flutter SDK Integration Guide**](https://support.freshchat.com/en/support/solutions/articles/50000003343-freshchat-flutter-sdk-integration-steps)

## iOS dependency manager support

From **v0.10.35** the plugin ships a Swift package (`ios/freshchat_sdk/Package.swift`)
alongside the CocoaPods podspec, so it works with **both**:

| Integration | Status | Notes |
| --- | --- | --- |
| Swift Package Manager | Supported | Requires Flutter 3.24+. Default in Flutter 3.44+; otherwise enable with `flutter config --enable-swift-package-manager`. |
| CocoaPods | Supported | No change. Continues to work exactly as before. |

Minimum iOS deployment target: **13.0**.

The native `FreshchatSDK` iOS framework is resolved automatically:

* **SPM** – from `https://github.com/freshworks-oss/freshchat-ios` (pinned to the version in `Package.swift`).
* **CocoaPods** – from the `FreshchatSDK` pod (pinned to the same version in `ios/freshchat_sdk.podspec`).

No manual step is needed for either. Run `flutter pub get` and build as usual.

### Push notifications (bridging header)

If your app forwards push notifications to Freshchat from a Swift `AppDelegate`,
the Objective-C bridging header import must use the module form so it resolves
under both SPM and CocoaPods:

```objc
// Runner-Bridging-Header.h
#import <freshchat_sdk/FreshchatSdkPlugin.h>
```

(Previously `#import "FreshchatSdkPlugin.h"`. The quoted form only resolves under
CocoaPods; the angle-bracket module form works for both.)

### iOS 27+ UIScene support

From iOS 27 onwards, the setup for the plugin changes, to support `UIScene`.

1) Add a new Swift file called `SceneDelegate` to your project, which extends `FlutterSceneDelegate`
2) Register that `SceneDelegate` in your Info.plist:
```xml
	<key>UIApplicationSceneManifest</key>
	<dict>
		<key>UIApplicationSupportsMultipleScenes</key>
		<false/>
		<key>UISceneConfigurations</key>
		<dict>
			<key>UIWindowSceneSessionRoleApplication</key>
			<array>
				<dict>
					<key>UISceneClassName</key>
					<string>UIWindowScene</string>
					<key>UISceneDelegateClassName</key>
					<string>$(PRODUCT_MODULE_NAME).SceneDelegate</string>
					<key>UISceneConfigurationName</key>
					<string>flutter</string>
					<key>UISceneStoryboardFile</key>
					<string>Main</string>
				</dict>
			</array>
		</dict>
	</dict>
```

   See https://docs.flutter.dev/release/breaking-changes/uiscenedelegate#create-a-scenedelegate-optional
3) Ensure that the `SceneDelegate` creates and shows the `FreshchatSdkPluginWindow` upon connecting to a UIScene

```swift
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
```
4) Remove the setup code that created a `FreshchatSdkPluginWindow` from your `AppDelegate.swift`

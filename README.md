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

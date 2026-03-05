import UIKit
import Flutter
import UserNotifications

@UIApplicationMain
class AppDelegate: FlutterAppDelegate {



    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // Register Flutter plugins
        GeneratedPluginRegistrant.register(with: self)
        
        if let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            
            // Get the existing window and rootViewController
            let rootViewController = windowScene.windows.first?.rootViewController
            
            // Create Freshchat SDK Window
            let freshchatWindow = FreshchatSdkPluginWindow(frame: UIScreen.main.bounds)
            freshchatWindow.windowScene = windowScene
            freshchatWindow.rootViewController = rootViewController
            freshchatWindow.makeKeyAndVisible()
            
            
        }
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.badge, .alert, .sound]
        ) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
                return
            }
            print("Notification permission granted: \(granted)")
            if granted {
                DispatchQueue.main.async {
                    print("Registering for remote notifications...")
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("Notification permission denied by user")
            }
            
        }
        UIApplication.shared.registerForRemoteNotifications()
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let freshchatSdkPlugin = FreshchatSdkPlugin()
        print("Device Token \(deviceToken)")
        print("Device token is set")
        freshchatSdkPlugin.setPushRegistrationToken(deviceToken)
    }
    
    override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("❌ Failed to register for remote notifications: \(error.localizedDescription)")
        print("Error details: \(error)")
        // Common causes:
        // - Running on iOS Simulator (remote notifications only work on real devices)
        // - Missing Push Notifications capability in Xcode
        // - Invalid provisioning profile
        // - Network connectivity issues
    }
    
    //@available(iOS 10.0, *)
    override func userNotificationCenter(_ center: UNUserNotificationCenter,
            willPresent: UNNotification,
            withCompletionHandler: @escaping (UNNotificationPresentationOptions)->()) {
        let freshchatSdkPlugin = FreshchatSdkPlugin()
    if freshchatSdkPlugin.isFreshchatNotification(willPresent.request.content.userInfo) {
        freshchatSdkPlugin.handlePushNotification(willPresent.request.content.userInfo) //Handled for freshchat notifications
    } else {
        withCompletionHandler([.alert, .sound, .badge]) //For other notifications
         }
    }
    //@available(iOS 10.0, *)
    override func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive: UNNotificationResponse,
                              withCompletionHandler: @escaping ()->()) {
        let freshchatSdkPlugin = FreshchatSdkPlugin()
    if freshchatSdkPlugin.isFreshchatNotification(didReceive.notification.request.content.userInfo) {
        freshchatSdkPlugin.handlePushNotification(didReceive.notification.request.content.userInfo) //Handled for freshchat notifications
           withCompletionHandler()
    } else {
           withCompletionHandler() //For other notifications
        }
    }
}

extension UIApplication {
    static var fcRootViewController: UIViewController? {
        return shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?
            .rootViewController
    }
}

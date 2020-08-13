import UIKit
import Flutter
import Firebase
import UserNotifications
import UserNotificationsUI
var notificationChannel : FlutterMethodChannel?
//var userJsonData: NSString?
@available(iOS 10.0, *)

@UIApplicationMain

@objc class AppDelegate: FlutterAppDelegate {
    var userJsonData = ""
    var notificationChannel: FlutterMethodChannel? = nil

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
           notificationChannel = FlutterMethodChannel(name: "io.byebye.inventory/platform_channel",
                                                      binaryMessenger: controller.binaryMessenger)
    notificationChannel!.setMethodCallHandler({
        (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        if ("getIntent" == call.method) {
            print("UserData \(self.userJsonData)")
            //NSDictionary *args = call.arguments;

            //NSString *text = [args valueForKey:@"text"];

            //[self startTTS:(text) result:(result)];

            result(self.userJsonData)
        } else {
            result(FlutterMethodNotImplemented)
        }
    })

    let center = UNUserNotificationCenter.current()
    center.delegate = self
    center.requestAuthorization(options: [.sound, .alert, .badge], completionHandler: { granted, error in
        if error == nil {
            // required to get the app to do anything at all about push notifications
            DispatchQueue.main.async(execute: {
                UIApplication.shared.registerForRemoteNotifications()
            })
            print("Push registration success.")
        } else {
            print("Push registration FAILED")
            print("ERROR: \((error as NSError?)?.localizedFailureReason ?? "") - \(error?.localizedDescription ?? "")")
            if let localizedRecoveryOptions = (error as NSError?)?.localizedRecoveryOptions {
                print("SUGGESTIONS: \(localizedRecoveryOptions) - \((error as NSError?)?.localizedRecoverySuggestion ?? "")")
            }
        }
    })

    GeneratedPluginRegistrant.register(with: self)
    if launchOptions != nil {
        DispatchQueue.main.async {
            if launchOptions![.remoteNotification] != nil {
                guard let data = launchOptions![.remoteNotification] as? [AnyHashable: Any] else {return}
                self.notificationData(userInfo: data)
            }
        }
    }
    return true
  }
    
    override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .alert, .badge])

    }
    
    override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Userinfo \(response.notification.request.content.userInfo)")
        self.notificationData(userInfo: response.notification.request.content.userInfo)
    }
    
    
    override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        print("Userinfo \(userInfo)")
        self.notificationData(userInfo: userInfo)
    }
    
    func notificationData(userInfo: [AnyHashable : Any]) {
        let data = userInfo
        let userData = data

        var jsonData: Data? = nil
        do {
            jsonData = try JSONSerialization.data(withJSONObject: userData, options: .prettyPrinted /* Pass 0 if you don't care about the readability of the generated string */)
        } catch {
        }

        if jsonData != nil {

            if let jsonData = jsonData {
                userJsonData = String(data: jsonData, encoding: .utf8)!
            }
        }

        print("UserDate : \(userData)")
        print("UserDate Json : \(userJsonData)")

        if notificationChannel != nil {
            print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
            DispatchQueue.main.async {
                self.notificationChannel?.invokeMethod("notification", arguments: self.userJsonData)
            }
        }
    }

    
}

extension UIApplication {
class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
    if let navigationController = controller as? UINavigationController {
        return topViewController(controller: navigationController.visibleViewController)
    }
    if let tabController = controller as? UITabBarController {
        if let selected = tabController.selectedViewController {
            return topViewController(controller: selected)
        }
    }
    if let presented = controller?.presentedViewController {
        return topViewController(controller: presented)
    }
    return controller
}
}



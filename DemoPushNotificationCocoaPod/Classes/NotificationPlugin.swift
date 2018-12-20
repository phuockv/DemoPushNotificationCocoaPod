import Foundation
import AWSCore
import AWSPinpoint
import AWSMobileClient
import UserNotifications
@objc public class NotificationPlugin: NSObject, UNUserNotificationCenterDelegate, UIApplicationDelegate {
    @objc open var pinpoint: AWSPinpoint?
    @objc public func registerForPushNotifications(_ launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        AWSMobileClient.sharedInstance().initialize { (userState, error) in
            if let error = error {
                print("Error initializing AWSMobileClient: (error.localizedDescription)")
            } else if let userState = userState {
                print("AWSMobileClient initialized. Current UserState: (userState.rawValue)")
            }
        }
        
        // Initialize Pinpoint
        let pinpointConfiguration = AWSPinpointConfiguration.defaultPinpointConfiguration(launchOptions: launchOptions)
        pinpoint = AWSPinpoint(configuration: pinpointConfiguration)
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        } else {
            // Fallback on earlier versions
            print("Fallback on earlier versions")
        }
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                (granted, error) in
                print("Permission granted: (granted)")
                // 1. Check if permission granted
                guard granted else { return }
                // 2. Attempt registration for remote notifications on the main thread
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        } else {
            // Fallback on earlier versions
            print("Fallback on earlier versions")
        }
    }
    
    @objc public func didRegisterForRemoteNotificationsWithDeviceToken(_ deviceToken: Data) {
        pinpoint!.notificationManager.interceptDidRegisterForRemoteNotifications(
            withDeviceToken: deviceToken)
    }
    
    @objc  public func didReceiveRemoteNotification(_ application: UIApplication,_ userInfo: [AnyHashable : Any],_ completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let aps = userInfo["aps"] as? NSDictionary {
            if let alert = aps["alert"] as? NSDictionary {
                let body = alert["body"] as? String
                let title = alert["title"] as? String
                pinpoint!.notificationManager.interceptDidReceiveRemoteNotification(
                    userInfo, fetchCompletionHandler: completionHandler)
                
                if (application.applicationState == .active) {
                    let alert = UIAlertController(title: title,
                                                  message: body,
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    
                    UIApplication.shared.keyWindow?.rootViewController?.present(
                        alert, animated: true, completion:nil)
                }
            }
        }
    }
    @objc public func applicationDidEnterBackground() {
        if let targetingClient = pinpoint?.targetingClient {
            targetingClient.addAttribute(["science", "politics", "travel"], forKey: "interests")
            targetingClient.updateEndpointProfile()
            let endpointId = targetingClient.currentEndpointProfile().endpointId
            print("Updated custom attributes for endpoint: (endpointId)")
        }
    }
}

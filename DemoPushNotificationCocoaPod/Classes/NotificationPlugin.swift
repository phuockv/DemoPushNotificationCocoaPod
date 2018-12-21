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
    
    @objc public func didRegisterForRemoteNotificationsWithDeviceToken(_ deviceToken: String) {
        let dataToken = Data(deviceToken.utf8)
        pinpoint!.notificationManager.interceptDidRegisterForRemoteNotifications(
            withDeviceToken: dataToken)
    }
    
}

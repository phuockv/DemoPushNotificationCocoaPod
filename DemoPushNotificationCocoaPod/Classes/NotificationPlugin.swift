import Foundation
import AWSCore
import AWSPinpoint
import AWSMobileClient
import UserNotifications

@UIApplicationMain

@objc public class NotificationPlugin: NSObject, UNUserNotificationCenterDelegate, UIApplicationDelegate {
 @objc public var pinpoint: AWSPinpoint?

    @objc public func registerForPushNotifications(_ deviceToken: Data,_ launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        AWSMobileClient.sharedInstance().initialize { (userState, error) in
            if error != nil {
                print("Error initializing AWSMobileClient: (error.localizedDescription)")
            } else if userState != nil {
                print("AWSMobileClient initialized. Current UserState: (userState.rawValue)")
            }
        }

        // Initialize Pinpoint
        let pinpointConfiguration = AWSPinpointConfiguration.defaultPinpointConfiguration(launchOptions: launchOptions)
        pinpoint = AWSPinpoint(configuration: pinpointConfiguration)
        
//        let dataToken = Data(deviceToken.utf8)
        pinpoint!.notificationManager.interceptDidRegisterForRemoteNotifications(
            withDeviceToken: deviceToken)
        
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        // 2. Print device token to use for PNs payloads
        print("Device Token: \(token)")
    }

//    @objc public func didRegisterForRemoteNotificationsWithDeviceToken(_ deviceToken: String) {
//
//        let dataToken = Data(deviceToken.utf8)
//        pinpoint!.notificationManager.interceptDidRegisterForRemoteNotifications(
//            withDeviceToken: dataToken)
//    }
    
}

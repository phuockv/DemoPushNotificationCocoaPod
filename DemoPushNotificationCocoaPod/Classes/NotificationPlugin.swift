import Foundation
import AWSCore
import AWSPinpoint
import AWSMobileClient
import UserNotifications
@objc public class NotificationPlugin: NSObject, UNUserNotificationCenterDelegate, UIApplicationDelegate {
//    @objc public func registerForPushNotifications(_ launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
//        AWSMobileClient.sharedInstance().initialize { (userState, error) in
//            if let error = error {
//                print("Error initializing AWSMobileClient: (error.localizedDescription)")
//            } else if let userState = userState {
//                print("AWSMobileClient initialized. Current UserState: (userState.rawValue)")
//            }
//        }
//
//        // Initialize Pinpoint
//        let pinpointConfiguration = AWSPinpointConfiguration.defaultPinpointConfiguration(launchOptions: launchOptions)
//        pinpoint = AWSPinpoint(configuration: pinpointConfiguration)
//
//    }
//
    var pinpoint: AWSPinpoint?
    @objc public func didRegisterForRemoteNotificationsWithDeviceToken(_ deviceToken: String) {
        

        AWSMobileClient.sharedInstance().initialize { (userState, error) in
            if let error = error {
                print("Error initializing AWSMobileClient: (error.localizedDescription)")
            } else if let userState = userState {
                print("AWSMobileClient initialized. Current UserState: (userState.rawValue)")
            }
        }
        
        // Initialize Pinpoint
        let pinpointConfiguration = AWSPinpointConfiguration.defaultPinpointConfiguration(launchOptions: nil)
         pinpoint = AWSPinpoint(configuration: pinpointConfiguration)
        let dataToken = Data(deviceToken.utf8)
        pinpoint!.notificationManager.interceptDidRegisterForRemoteNotifications(
            withDeviceToken: dataToken)
    }
    
}

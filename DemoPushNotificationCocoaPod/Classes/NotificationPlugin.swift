import Foundation
import AWSCore
import AWSPinpoint
import AWSMobileClient
import UserNotifications
@objc public class NotificationPlugin: NSObject, UNUserNotificationCenterDelegate, UIApplicationDelegate {
 @objc public var pinpoint: AWSPinpoint?

    @objc public func registerForPushNotifications(_ launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
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

    }

    @objc public func didRegisterForRemoteNotificationsWithDeviceToken(_ deviceToken: String) {

        let dataToken = Data(deviceToken.utf8)
        pinpoint!.notificationManager.interceptDidRegisterForRemoteNotifications(
            withDeviceToken: dataToken)
    }
    
}

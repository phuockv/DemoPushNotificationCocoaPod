import Foundation
import AWSCore
import AWSPinpoint
import AWSMobileClient
import UserNotifications
@objc public class NotificationPlugin: NSObject, UNUserNotificationCenterDelegate, UIApplicationDelegate {
    
    @objc public func didRegisterForRemoteNotificationsWithDeviceToken1(_ deviceToken: String) {
        AWSMobileClient.sharedInstance().initialize { (userState, error) in
            if let error = error {
                print("Error initializing AWSMobileClient: (error.localizedDescription)")
            } else if let userState = userState {
                print("AWSMobileClient initialized. Current UserState: (userState.rawValue)")
            }
        }
        
        // Initialize Pinpoint
        let pinpointConfiguration = AWSPinpointConfiguration.defaultPinpointConfiguration(launchOptions: nil)
        let pinpoint = AWSPinpoint(configuration: pinpointConfiguration)
        let dataToken = Data(deviceToken.utf8)
        pinpoint!.notificationManager.interceptDidRegisterForRemoteNotifications(
            withDeviceToken: dataToken)
    }
    
}

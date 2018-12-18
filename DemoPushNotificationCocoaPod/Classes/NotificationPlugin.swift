//
//  hello.swift
//  Pods
//
//  Created by dev on 12/10/18.
//

//
//  pluginPushNotification.swift
//  pluginPushNotification
//
//  Created by dev on 11/29/18.
//  Copyright © 2018 pluginPushNotification. All rights reserved.
//

import Foundation
import AWSCore

import AWSPinpoint
import AWSMobileClient
import UserNotifications

@objc public class NotificationPlugin: NSObject ,UNUserNotificationCenterDelegate{
    var pinpoint: AWSPinpoint?
    
    @objc public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        AWSMobileClient.sharedInstance().initialize { (userState, error) in
            if let error = error {
                print("Error initializing AWSMobileClient: \(error.localizedDescription)")
            } else if let userState = userState {
                print("AWSMobileClient initialized. Current UserState: \(userState.rawValue)")
            }
        }
        
        // Initialize Pinpoint
        let pinpointConfiguration = AWSPinpointConfiguration.defaultPinpointConfiguration(launchOptions: launchOptions)
        pinpoint = AWSPinpoint(configuration: pinpointConfiguration)
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                (granted, error) in
                print("Permission granted: \(granted)")
                
                // 1. Check if permission granted
                guard granted else {
                    return
                    
                }
                
                // 2. Attempt registration for remote notifications on the main thread
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                    
                }
            }
        } else {
            // Fallback on earlier versions
        }
        return true
    }
    
    @objc public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        pinpoint!.notificationManager.interceptDidRegisterForRemoteNotifications(
            withDeviceToken: deviceToken)
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        // 2. Print device token to use for PNs payloads
        print("Device Token: \(token)")
    }
    public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
    
    
    
    @objc public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
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
    
    @objc public func applicationDidEnterBackground(_ application: UIApplication) {
        if let targetingClient = pinpoint?.targetingClient {
            targetingClient.addAttribute(["science", "politics", "travel"], forKey: "interests")
            targetingClient.updateEndpointProfile()
            let endpointId = targetingClient.currentEndpointProfile().endpointId
            print("Updated custom attributes for endpoint: \(endpointId)")
        }
        
    }
    
}


//
//  SimpleAPNProjectApp.swift
//  SimpleAPNProject
//
//  Created by Ioannis Andreoulakis on 20/9/24.
//

import Firebase
import FirebaseCore
import FirebaseAnalytics
import FirebaseMessaging
import UserNotifications
import SwiftUI

//final class AppDelegate: NSObject, UIApplicationDelegate {
//    func application(
//        _ application: UIApplication,
//        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil
//    ) -> Bool {
//        FirebaseApp.configure()
//
//        Messaging.messaging().delegate = self
//
//        UNUserNotificationCenter.current().delegate = self
//
//        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _, _ in })
//
//        application.registerForRemoteNotifications()
//
//        Messaging.messaging().token { token, error in
//            if let error {
//                print("Error fetching FCM registration token: \(error)")
//            } else if let token {
//                print("FCM registration token: \(token)")
//            }
//        }
//
//        return true
//    }
//
//    func application(_: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        print("Oh no! Failed to register for remote notifications with error \(error)")
//    }
//
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        var readableToken = ""
//        for index in 0 ..< deviceToken.count {
//            readableToken += String(format: "%02.2hhx", deviceToken[index] as CVarArg)
//        }
//        print("Received an APNs device token: \(readableToken)")
//
//        // Set the APNs token to Firebase Messaging
//        Messaging.messaging().apnsToken = deviceToken
//        
//        // Re-fetch the FCM token after the APNs token is set
//        Messaging.messaging().token { token, error in
//            if let error {
//                print("Error fetching FCM registration token: \(error)")
//            } else if let token {
//                print("FCM registration token: \(token)")
//            }
//        }
//    }
//
//}
//
//extension AppDelegate: MessagingDelegate {
//    @objc func messaging(_: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//        print("Firebase token: \(String(describing: fcmToken))")
//    }
//}
//
//extension AppDelegate: UNUserNotificationCenterDelegate {
//    func userNotificationCenter(
//        _: UNUserNotificationCenter,
//        willPresent _: UNNotification,
//        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
//    ) {
//        completionHandler([[.banner, .list, .sound]])
//    }
//
//    func userNotificationCenter(
//        _: UNUserNotificationCenter,
//        didReceive response: UNNotificationResponse,
//        withCompletionHandler completionHandler: @escaping () -> Void
//    ) {
//        let userInfo = response.notification.request.content.userInfo
//        NotificationCenter.default.post(
//            name: Notification.Name("didReceiveRemoteNotification"),
//            object: nil,
//            userInfo: userInfo
//        )
//        completionHandler()
//    }
//}
//
//
//@main
//struct CloudMessagingIosApp: App {
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//    }
//}



class AppDelegate: NSObject, UIApplicationDelegate {
    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()

        Messaging.messaging().delegate = self

        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        return true
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

      print(userInfo)

      completionHandler(UIBackgroundFetchResult.newData)
    }
}


extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {

      let deviceToken:[String: String] = ["token": fcmToken ?? ""]
        print("Device token: ", deviceToken) // This token can be used for testing notifications on FCM
    }
}


@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {

  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo

    if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
    }

    print(userInfo)

    // Change this to your preferred presentation option
    completionHandler([[.banner, .badge, .sound]])
  }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {

    }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo

    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID from userNotificationCenter didReceive: \(messageID)")
    }

    print(userInfo)

    completionHandler()
  }
}


@main
struct ProjectNameApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

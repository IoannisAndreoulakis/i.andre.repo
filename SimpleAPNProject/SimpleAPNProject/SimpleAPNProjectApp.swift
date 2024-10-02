//
//  SimpleAPNProjectApp.swift
//  SimpleAPNProject
//
//  Created by Ioannis Andreoulakis on 20/9/24.
//

import SwiftUI
import FirebaseCore
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        application.registerForRemoteNotifications()
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            Messaging.messaging().apnsToken = deviceToken
        }
        
        
        func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
            if let fcm = Messaging.messaging().fcmToken {
                print("fcm", fcm)
            }
        }
    
}



@main
struct SimpleAPNProjectApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

//
//  AppDelegate.Firebase.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/12/04.
//

import UIKit
import Firebase
import UserNotifications
import FirebaseMessaging

// https://nsios.tistory.com/191
extension AppDelegate {

    func configureFirebase(_ application: UIApplication) {
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.sound, .alert, .badge]) { isAgree, error in
                
                if isAgree {
                    print("알림허용")
                }
            }
        application.registerForRemoteNotifications()
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    /// 푸시클릭시
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        print("🟢", #function)
        
        let userInfo = response.notification.request.content.userInfo as NSDictionary
        print("🌸 ", userInfo)
    }
    
    /// 앱화면 보고있는중에 푸시올 때
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        print("🟢", #function)
        
        return [.sound, .banner, .list]
    }
    
    /// FCMToken 업데이트시
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("🟢 fcmToken:: - \(fcmToken)")
    }
    
    /// 스위즐링 NO시, APNs등록, 토큰값가져옴
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("🟢", #function, deviceTokenString)
    }
    
    /// error발생시
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("🟢", error)
    }
}

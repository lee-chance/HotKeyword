//
//  AppDelegate.swift
//  HotKeyword
//
//  Created by Changsu Lee on 2022/06/12.
//

import UIKit
import FirebaseMessaging

final class AppDelegate: NSObject, UIApplicationDelegate {
    // 앱 실행시 실행되는 메소드
    // 원격 알림 등록
    // https://firebase.google.com/docs/cloud-messaging/ios/client?hl=ko&authuser=0#register_for_remote_notifications
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        Messaging.messaging().delegate = self
        
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        
        application.registerForRemoteNotifications()
        
        return true
    }
    
    // APN 토큰과 등록 토큰 매핑
    // https://firebase.google.com/docs/cloud-messaging/ios/client?hl=ko&authuser=0#token-swizzle-disabled
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    // APN 토큰과 등록 토큰 매핑 실패
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        Logger.notice("Failed to register: \(error.localizedDescription)")
    }
}

extension AppDelegate : UNUserNotificationCenterDelegate {
    // 포그라운드에서 알림 받았을 때
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        let userInfo = notification.request.content.userInfo
        Logger.info("Will Present User Info: \(userInfo)")
        
        completionHandler([[.badge, .banner, .sound]])
    }
    
    // 백그라운드에서 알림 받았을 때
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        
        if response.actionIdentifier == "accept" {
            Logger.info("Did Receive User Info: \(userInfo)")
            
            completionHandler()
        }
    }
    
    // 자동 푸시 알림 처리
    // https://firebase.google.com/docs/cloud-messaging/ios/receive?hl=ko&authuser=0#handle_silent_push_notifications
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        Logger.info(userInfo)
        completionHandler(.newData)
    }
}

extension AppDelegate: MessagingDelegate {
    // 토큰 갱신 모니터링
    // https://firebase.google.com/docs/cloud-messaging/ios/client?hl=ko&authuser=0#monitor-token-refresh
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        Logger.info("Firebase registration token: \(String(describing: fcmToken))")
    }
}

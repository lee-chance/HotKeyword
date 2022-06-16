//
//  FCMManager.swift
//  HotKeyword
//
//  Created by Changsu Lee on 2022/06/15.
//

import Foundation
import FirebaseMessaging

final class FCMManager {
    static func subscribe(topic: Topic, failure: ((Error) -> Void)? = nil) {
        getPermissionState { error in
            if let error = error {
                failure?(error)
                return
            } else {
                let topicName = topic.rawValue
                
                Messaging.messaging().subscribe(toTopic: topicName) { error in
                    if let error = error {
                        print("Subscribed to \(topicName) topic error: \(error)")
                        failure?(error)
                    } else {
                        // TODO: UserDefaults에 저장하기
                        print("Subscribed to \(topicName) topic")
                    }
                }
            }
        }
    }
    
    static func unsubscribe(topic: Topic, failure: ((Error) -> Void)? = nil) {
        let topicName = topic.rawValue
        
        Messaging.messaging().unsubscribe(fromTopic: topicName) { error in
            if let error = error {
                print("Unsubscribed to \(topicName) topic error: \(error)")
                failure?(error)
            } else {
                print("Unsubscribed to \(topicName) topic")
            }
        }
    }
    
    static func unsubscribeAllTopics(failure: ((Error) -> Void)? = nil) {
        for topic in Topic.allTopics {
            unsubscribe(topic: topic, failure: failure)
        }
    }
    
    static func token(competion: @escaping (String?, Error?) -> Void) {
        Messaging.messaging().token(completion: competion)
    }
    
    static private func getPermissionState(completion: @escaping (NotificationPermissionError?) -> Void) {
        let current = UNUserNotificationCenter.current()
        current.getNotificationSettings { permission in
            switch permission.authorizationStatus {
            case .authorized:
                print("User granted permission for notification")
                completion(nil)
            case .denied:
                print("User denied notification permission")
                completion(.denied)
            case .notDetermined:
                print("Notification permission haven't been asked yet")
                completion(.notDetermined)
            case .provisional:
                // @available(iOS 12.0, *)
                print("The application is authorized to post non-interruptive user notifications.")
                completion(nil)
            case .ephemeral:
                // @available(iOS 14.0, *)
                print("The application is temporarily authorized to post notifications. Only available to app clips.")
                completion(nil)
            @unknown default:
                print("Unknow Status")
                completion(.unknow)
            }
        }
    }
}

extension FCMManager {
    enum Topic {
        case hotKeyword(clock: Int)
        
        var rawValue: String {
            switch self {
            case .hotKeyword(let clock):
                return "HotKeywordAt\(clock)"
            }
        }
        
        static var allTopics: [Topic] {
            var result = [Topic]()
            for clock in 0..<24 {
                result.append(.hotKeyword(clock: clock))
            }
            return result
        }
    }
    
    private enum NotificationPermissionError: Error {
        case denied, notDetermined, unknow
    }
}

//
//  HotKeywordApp.swift
//  HotKeyword
//
//  Created by 이창수 on 2022/05/04.
//

import SwiftUI
import Firebase
import GoogleMobileAds

@main
struct HotKeywordApp: App {
    @StateObject var settings = AppSettings.shared
    @StateObject var dialog = DialogPresentation.shared
    
    init() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(settings)
                .environmentObject(dialog)
                .customDialog(presentationManager: dialog)
        }
    }
}

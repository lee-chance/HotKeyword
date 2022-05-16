//
//  HotKeywordApp.swift
//  HotKeyword
//
//  Created by 이창수 on 2022/05/04.
//

import SwiftUI
import Firebase

@main
struct HotKeywordApp: App {
    @StateObject var settings = AppSettings()
    
    init() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(settings)
        }
    }
}

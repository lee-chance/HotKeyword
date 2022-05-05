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
    let hotKeywordViewModel = HotKeywordViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: hotKeywordViewModel)
                .environmentObject(settings)
        }
    }
}

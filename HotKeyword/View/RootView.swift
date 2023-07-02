//
//  RootView.swift
//  HotKeyword
//
//  Created by 이창수 on 2022/05/13.
//

import SwiftUI

struct RootView: View {
    @AppStorage(AppStorageKey.isFirstOpened.key) var isFirstOpen: Bool = true
    @State private var presentOnboardingView: Bool = false
    
    var body: some View {
        ZStack {
            MainView()
            
            SplashView()
                .zIndex(1)
                .onDisappear {
                    if isFirstOpen { presentOnboardingView.toggle() }
                }
        }
        .fullScreenCover(isPresented: $presentOnboardingView, onDismiss: {
            #if DEBUG
            #else
            isFirstOpen = false
            #endif
        }, content: {
            OnboardingView()
        })
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}

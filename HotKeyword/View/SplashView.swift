//
//  SplashView.swift
//  HotKeyword
//
//  Created by 이창수 on 2022/05/13.
//

import SwiftUI

struct SplashView: View {
    @ObservedObject var splash = SplashViewModel()
    
    @ViewBuilder
    var body: some View {
        if splash.showsSplashView {
            GeometryReader { geometry in
                Image("backgroundImage")
                    .resizable()
                
                Text("🔥")
                    .font(.system(size: 80))
                    .position(x: geometry.size.width / 2, y: splash.isLogoAnimationOn ? geometry.size.height / 2 : -geometry.size.height)
            }
            .ignoresSafeArea()
            .transition(.move(edge: .top))
            .zIndex(1)
        } else {
            EmptyView()
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}

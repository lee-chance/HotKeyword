//
//  SplashView.swift
//  HotKeyword
//
//  Created by 이창수 on 2022/05/13.
//

import SwiftUI

struct SplashView: View {
    @State private var isLogoAnimationOn = false
    @State private var showSplashView = true
    
    var body: some View {
        if showSplashView {
            GeometryReader { geometry in
                Color.purple
                
                Text("🔥")
                    .font(.system(size: 80))
                    .position(x: geometry.size.width / 2, y: isLogoAnimationOn ? geometry.size.height / 2 : -geometry.size.height)
            }
            .transition(.move(edge: .top))
            .zIndex(1)
            .onAppear {
                withAnimation(.spring(response: 0.7, dampingFraction: 0.6)) {
                    isLogoAnimationOn.toggle()
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.35) {
                    withAnimation {
                        showSplashView.toggle()
                    }
                }
            }
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

//
//  RootView.swift
//  HotKeyword
//
//  Created by 이창수 on 2022/05/13.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        ZStack {
            MainView(viewModel: HotKeywordViewModel())
            
            SplashView()
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}

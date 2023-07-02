//
//  MainView.swift
//  HotKeyword
//
//  Created by 이창수 on 2022/05/04.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = HotKeywordViewModel()
    
    var body: some View {
        TabView(selection: $viewModel.tabSelection) {
            WeatherForecastView(viewModel: ForecastViewModel())
                .tabItem {
                    Image(systemName: "sun.max.fill")
                    
                    Text(MainTab.forecast.name)
                }
                .tag(MainTab.forecast)
            
            HotKeywordView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "rectangle.and.text.magnifyingglass")
                    
                    Text(MainTab.keyword.name)
                }
                .tag(MainTab.keyword)
            
//            HotNewsView(viewModel: viewModel)
//                .tabItem {
//                    Image(systemName: "newspaper.fill")
//
//                    Text(MainTab.news.name)
//                }
//                .tag(MainTab.news)
            
            SettingView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    
                    Text(MainTab.settings.name)
                }
                .tag(MainTab.settings)
        }
        .onAppear {
            viewModel.hotKeywordBinding()
//            viewModel.hotNewsBinding()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .preferredColorScheme(.dark)
    }
}

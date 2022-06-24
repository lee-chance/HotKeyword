//
//  MainView.swift
//  HotKeyword
//
//  Created by 이창수 on 2022/05/04.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var settings: AppSettings
    @StateObject var viewModel: HotKeywordViewModel
    
    @State private var showSettingView = false
    
    var body: some View {
        NavigationView {
            TabView(selection: $viewModel.tabSelection) {
                HotKeywordView(viewModel: viewModel)
                    .tabItem {
                        Image(systemName: "rectangle.and.text.magnifyingglass")
                        
                        Text(MainTab.keyword.name)
                    }
                    .tag(MainTab.keyword)
                
                HotNewsView(viewModel: viewModel)
                    .tabItem {
                        Image(systemName: "newspaper.fill")
                        
                        Text(MainTab.news.name)
                    }
                    .tag(MainTab.news)
            }
            .navigationBarTitle(viewModel.navigationTitle)
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        showSettingView.toggle()
                    }) {
                        Image(systemName: "gearshape.fill")
                            .resizable()
                            .frame(width: 16, height: 16)
                    }
                    .foregroundColor(.text)
                }
            }
            .background(
                NavigationLink(destination: SettingView(), isActive: $showSettingView) {
                    EmptyView()
                }
            )
        }
        .onAppear {
            viewModel.hotKeywordBinding()
            viewModel.hotNewsBinding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: HotKeywordViewModel())
            .preferredColorScheme(.dark)
    }
}

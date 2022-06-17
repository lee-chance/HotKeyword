//
//  MainView.swift
//  HotKeyword
//
//  Created by 이창수 on 2022/05/04.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var settings: AppSettings
    @ObservedObject var viewModel: HotKeywordViewModel
    
    @State private var showSettingView = false
    
    private let bottomBannerHeight: CGFloat = Screen.height > 600 ? 100 : 50
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                List {
                    Section {
                        ForEach(viewModel.keywords, id: \.id) { keyword in
                            Button(action: {
                                viewModel.search(keyword: keyword.text, from: settings.searchEngine)
                            }) {
                                KeywordRow(keyword: keyword)
                            }
                            
                            if keyword.rank == 10 {
                                GoogleADBannerView(unitID: GoogleADKey.mainListBanner.keyValue)
                            }
                        }
                    } header: {
                        UpdatedDateText(updatedDate: viewModel.updatedDate)
                            .animation(nil)
                    }
                }
                .padding(.bottom, bottomBannerHeight)
                .listStyle(.insetGrouped)
                .accentColor(.text)
                
                GoogleADBannerView(unitID: GoogleADKey.mainBanner.keyValue)
                    .frame(height: bottomBannerHeight)
            }
            .navigationBarTitle("🔥 실시간 인기 검색어")
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
        .ignoresSafeArea()
        .onAppear {
            viewModel.hotKeywordBinding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: HotKeywordViewModel())
            .preferredColorScheme(.dark)
    }
}

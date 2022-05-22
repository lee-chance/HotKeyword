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
    
    private let bottomBannerHeight: CGFloat = 100
    
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
                        Text("\(viewModel.updatedDate.toString(format: "HH시 mm분 ss초"))")
                            .font(Font.caption)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .trailing)
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
                    if #available(iOS 15.0, *) {
                        Button(action: {
                            showSettingView.toggle()
                        }) {
                            Image(systemName: "gearshape.fill")
                                .resizable()
                                .frame(width: 16, height: 16)
                                .foregroundColor(.text)
                        }
                    } else {
                        Image(systemName: "gearshape.fill")
                            .resizable()
                            .foregroundColor(.text)
                            .frame(width: 20, height: 20)
                            .onTapGesture {
                                showSettingView.toggle()
                            }
                    }
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

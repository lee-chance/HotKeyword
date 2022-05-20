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
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(viewModel.keywords, id: \.id) { keyword in
                        Button(action: {
                            viewModel.search(keyword: keyword.text, from: settings.searchEngine)
                        }) {
                            KeywordRow(keyword: keyword)
                        }
                    }
                } header: {
                    Text("\(viewModel.updatedDate.toString(format: "HH시 mm분"))")
                        .font(Font.caption)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .animation(nil)
                }
            }
            .background(
                NavigationLink(destination: SettingView(), isActive: $showSettingView) {
                    EmptyView()
                }
            )
            .listStyle(.insetGrouped)
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
            .accentColor(.text)
        }
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

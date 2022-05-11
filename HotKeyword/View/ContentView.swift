//
//  ContentView.swift
//  HotKeyword
//
//  Created by 이창수 on 2022/05/04.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var settings: AppSettings
    @ObservedObject var viewModel: HotKeywordViewModel
    
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
                }
            }
            .navigationBarTitle("🔥 실시간 인기 검색어")
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        
                    }) {
                        Image(systemName: "gearshape.fill")
                            .resizable()
                            .frame(width: 16, height: 16)
                            .foregroundColor(.text)
                    }
                }
            }
        }
        .onAppear {
            viewModel.hotKeywordBinding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: HotKeywordViewModel())
            .preferredColorScheme(.dark)
    }
}

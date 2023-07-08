//
//  HotKeywordView.swift
//  HotKeyword
//
//  Created by Changsu Lee on 2022/06/24.
//

import SwiftUI

struct HotKeywordView: View {
    @EnvironmentObject private var settings: AppSettings
    @StateObject var viewModel: HotKeywordViewModel
    @State private var text: String = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack(alignment: .bottom) {
            List {
                Section {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        
                        TextField("\(settings.searchEngine.kor)에서 빠른 검색", text: $text)
                            .focused($isFocused)
                            .onSubmit {
                                if !text.isEmpty {
                                    viewModel.search(keyword: text, from: settings.searchEngine)
                                }
                            }
                        
                        if !text.isEmpty {
                            Button(action: {
                                text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                
                Section {
                    ForEach(viewModel.keywords, id: \.id) { keyword in
                        Button(action: {
                            viewModel.search(keyword: keyword.text, from: settings.searchEngine)
                        }) {
                            KeywordRow(keyword: keyword)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        
                        if keyword.rank == 10 && !settings.adFree {
                            GoogleADBannerView(unitID: GoogleADKey.mainListBanner.keyValue)
                        }
                    }
                } header: {
                    HStack(alignment: .bottom) {
                        Text("인기 검색어")
                            .font(.largeTitle)
                        
                        UpdatedDateText(updatedDate: viewModel.updatedDate)
                    }
                }
            }
            .padding(.top, 1)
            .padding(.bottom, viewModel.bottomBannerHeight)
            .listStyle(.insetGrouped)
            .background(Color(uiColor: .systemGray6))
            
            if !settings.adFree {
                GoogleADBannerView(unitID: GoogleADKey.mainBanner.keyValue)
                    .frame(height: viewModel.bottomBannerHeight)
            }
        }
        .onTapGesture {
            isFocused = false
        }
        .sheet(item: $viewModel.openURL) { _ in
            HotWebView(viewModel: viewModel)
        }
    }
}

struct HotKeywordView_Previews: PreviewProvider {
    static var previews: some View {
        HotKeywordView(viewModel: HotKeywordViewModel())
            .environmentObject(AppSettings.shared)
    }
}

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
    
    var body: some View {
        ZStack(alignment: .bottom) {
            List {
                Section {
                    ForEach(viewModel.keywords, id: \.id) { keyword in
                        Button(action: {
                            viewModel.search(keyword: keyword.text, from: settings.searchEngine)
                        }) {
                            KeywordRow(keyword: keyword)
                        }
                        
                        if keyword.rank == 10 && !settings.adFree {
                            GoogleADBannerView(unitID: GoogleADKey.mainListBanner.keyValue)
                        }
                    }
                } header: {
                    UpdatedDateText(updatedDate: viewModel.updatedDate)
                }
            }
            .padding(.bottom, viewModel.bottomBannerHeight)
            .listStyle(.insetGrouped)
            
            if !settings.adFree {
                GoogleADBannerView(unitID: GoogleADKey.mainBanner.keyValue)
                    .frame(height: viewModel.bottomBannerHeight)
            }
        }
    }
}

struct HotKeywordView_Previews: PreviewProvider {
    static var previews: some View {
        HotKeywordView(viewModel: HotKeywordViewModel())
            .environmentObject(AppSettings.shared)
    }
}

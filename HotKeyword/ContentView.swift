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
        VStack {
            Text("\(viewModel.updatedDate.toString())")
            
            List {
                ForEach(viewModel.keywords, id: \.id) { keyword in
                    Button(action: {
                        viewModel.search(keyword: keyword.text, from: settings.searchEngine)
                    }) {
                        Text("\(keyword.rank) \(keyword.text)")
                            .foregroundColor(.black)
                    }
                }
            }
        }
        .onAppear {
            viewModel.updateHotKeywords()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: HotKeywordViewModel())
    }
}

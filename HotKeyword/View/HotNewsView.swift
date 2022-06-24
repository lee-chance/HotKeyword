//
//  HotNewsView.swift
//  HotKeyword
//
//  Created by Changsu Lee on 2022/06/24.
//

import SwiftUI

struct HotNewsView: View {
    @StateObject var viewModel: HotKeywordViewModel
    
    var body: some View {
        VStack {
            ForEach(viewModel.news) { article in
                Text(article.title)
            }
        }
    }
}

//struct HotNewsView_Previews: PreviewProvider {
//    static var previews: some View {
//        HotNewsView()
//    }
//}

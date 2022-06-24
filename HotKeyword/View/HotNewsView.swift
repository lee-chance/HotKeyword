//
//  HotNewsView.swift
//  HotKeyword
//
//  Created by Changsu Lee on 2022/06/24.
//

import SwiftUI

struct HotNewsView: View {
    @StateObject var viewModel: HotKeywordViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(spacing: 32) {
                    ForEach(viewModel.news) { article in
                        VStack(spacing: 0) {
                            Color.clear
                                .frame(maxWidth: .infinity)
                                .aspectRatio(5 / 3, contentMode: .fit)
                                .background(
                                    ZStack {
                                        if #available(iOS 15.0, *) {
                                            AsyncImage(url: article.imageURL) { image in
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(maxWidth: .infinity)
                                            } placeholder: {
                                                Text("loading...")
                                            }
                                        } else {
                                            AsyncImageUnderiOS15(url: article.imageURL) { image in
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(maxWidth: .infinity)
                                            } placeholder: {
                                                Text("loading...")
                                            }
                                        }
                                    }
                                )
                                .cornerRadius(8, corners: .top)
                                .clipped()
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(article.publishedAtFormNow)
                                    .font(.callout)
                                    .foregroundColor(.gray)
                                
                                Text(article.title)
                                    .font(.headline)
                                    .foregroundColor(.text)
                                
                                Text(article.description)
                                    .font(.body)
                                    .lineLimit(2)
                                    .foregroundColor(.text)
                            }
                            .padding()
                        }
                        .background(
                            ZStack {
                                if colorScheme == .dark {
                                    Color.white
                                        .opacity(0.15)
                                        .cornerRadius(8)
                                } else {
                                    Color.white
                                        .cornerRadius(8)
                                        .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 0)
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal)
                .padding(.top, 48)
                .padding(.bottom, 100)
            }
            
            if !AppSettings.shared.adFree {
                GoogleADBannerView(unitID: GoogleADKey.mainBanner.keyValue)
                    .frame(height: viewModel.bottomBannerHeight)
            }
        }
    }
}

//struct HotNewsView_Previews: PreviewProvider {
//    static var previews: some View {
//        HotNewsView()
//    }
//}

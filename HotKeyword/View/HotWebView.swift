//
//  HotWebView.swift
//  HOT
//
//  Created by Changsu Lee on 2023/07/08.
//

import SwiftUI
import WebKit

struct HotWebView: View {
    @EnvironmentObject private var settings: AppSettings
    @StateObject var viewModel: HotKeywordViewModel
    @State private var keywordIndex: Int = 0
    
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    init(viewModel: HotKeywordViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                if let _ = viewModel.openURL {
                    CarouselView(axis: .vertical, data: viewModel.keywords, index: $keywordIndex) { keyword in
                        Button(action: {
                            viewModel.openURL = nil
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                viewModel.search(keyword: keyword.text, from: settings.searchEngine)
                            }
                        }) {
                            KeywordRow(keyword: keyword)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                    .onReceive(timer) { value in
                        if keywordIndex + 1 == viewModel.keywords.count {
                            keywordIndex = 0
                        } else {
                            keywordIndex += 1
                        }
                    }
                }
                
                Spacer()
                
                Button(action: {
                    viewModel.openURL = nil
                }) {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .frame(width: 48, height: 48)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal)
            .frame(maxHeight: 48)
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color(uiColor: .systemGray6))
            
            if let url = viewModel.openURL {
                WebView(url: url)
            } else {
                ProgressView()
            }
        }
    }
}

struct HotWebView_Previews: PreviewProvider {
    static var previews: some View {
        HotWebView(viewModel: HotKeywordViewModel())
            .environmentObject(AppSettings())
    }
}

private struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let preferences = WKPreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = false // JavaScript가 사용자 상호 작용없이 창을 열 수 있는지 여부
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.isScrollEnabled = true
        
        webView.load(URLRequest(url: url))
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) { }
}

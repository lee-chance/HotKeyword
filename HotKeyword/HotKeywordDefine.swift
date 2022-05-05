//
//  HotKeywordDefine.swift
//  HotKeyword
//
//  Created by 이창수 on 2022/05/04.
//

import Foundation

enum SearchEngine {
    case google
    case naver
    case daum
    case bing
    
    var urlString: String {
        switch self {
        case .google: return "https://www.google.com/search?q="
            // https://www.google.com/search?q=1
        case .naver: return "https://search.naver.com/search.naver?query="
            // https://search.naver.com/search.naver?query=1
        case .daum: return "https://search.daum.net/search?q="
            // https://search.daum.net/search?q=1
        case .bing: return "https://www.bing.com/search?q="
            // https://www.bing.com/search?q=1
        }
    }
}

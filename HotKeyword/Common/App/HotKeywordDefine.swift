//
//  HotKeywordDefine.swift
//  HotKeyword
//
//  Created by 이창수 on 2022/05/04.
//

import Foundation

enum UserDefaultsKey {
    case searchEngine
    
    var key: String {
        "com.cslee.HotKeyword.\(self)"
    }
}

enum SearchEngine: String, CaseIterable, Identifiable {
    case google
    case naver
    case daum
    case bing
    
    var id: String { self.rawValue }
    
    var kor: String {
        switch self {
        case .google: return "구글"
        case .naver: return "네이버"
        case .daum: return "다음"
        case .bing: return "빙"
        }
    }
    
    var urlString: String {
        switch self {
        case .google: return "https://www.google.com/search?q="
        case .naver: return "https://search.naver.com/search.naver?query="
        case .daum: return "https://search.daum.net/search?q="
        case .bing: return "https://www.bing.com/search?q="
        }
    }
}

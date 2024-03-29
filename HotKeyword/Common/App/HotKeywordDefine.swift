//
//  HotKeywordDefine.swift
//  HotKeyword
//
//  Created by 이창수 on 2022/05/04.
//

import Foundation

enum HotValue: String {
    case hotKeywordsCollectionName
    case hotNewsCollectionName
    
    var rawValue: String {
        switch self {
        case .hotKeywordsCollectionName:
            return "keywords"
        case .hotNewsCollectionName:
            return "news"
        }
    }
}

enum AppStorageKey {
    case searchEngine
    case allowsNotification
    case isFirstOpened
    
    var key: String {
        "com.cslee.HotKeyword.\(self)"
    }
}

enum SearchEngine: String, CaseIterable, Identifiable {
    case naver
    case daum
    case google
    case bing
    
    var id: Self { self }
    
    var kor: String {
        switch self {
        case .naver: return "네이버"
        case .daum: return "다음"
        case .google: return "구글"
        case .bing: return "빙"
        }
    }
    
    var urlString: String {
        switch self {
        case .naver: return "https://search.naver.com/search.naver?query="
        case .daum: return "https://search.daum.net/search?q="
        case .google: return "https://www.google.com/search?q="
        case .bing: return "https://www.bing.com/search?q="
        }
    }
}

enum GoogleADKey {
    case mainBanner
    case mainListBanner
    
    var keyValue: String {
        #if DEBUG
        return "ca-app-pub-3940256099942544/2934735716"
        #else
        switch self {
        case .mainBanner:
            return "ca-app-pub-3500187310501965/9229805331"
        case .mainListBanner:
            return "ca-app-pub-3500187310501965/3320671404"
        }
        #endif
    }
}

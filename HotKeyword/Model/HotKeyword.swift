//
//  HotKeyword.swift
//  HotKeyword
//
//  Created by 이창수 on 2022/05/04.
//

import SwiftUI

struct HotKeyword: Identifiable, Codable {
    let rank: Int
    let text: String
    
    var id: String { text }
    
    var backgroundColor: Color {
        switch rank {
        case 1: return .gold
        case 2: return .silver
        case 3: return .bronze
        default: return .gray
        }
    }
}

struct InternalKeywordValue: Codable {
    let point: Double
    let updatedAt: Date
}

extension HotKeyword {
    static func dummy() -> [HotKeyword] {
        #if DEBUG
        [
            HotKeyword(rank: 1, text: "HOT"),
            HotKeyword(rank: 2, text: "실시간 인기 검색어"),
            HotKeyword(rank: 3, text: "실검"),
            HotKeyword(rank: 4, text: "실검순위"),
            HotKeyword(rank: 5, text: "HOT 실검"),
            HotKeyword(rank: 6, text: "HOT 실시간 인기 검색어"),
            HotKeyword(rank: 7, text: "대한민국 실검"),
            HotKeyword(rank: 8, text: "대한민국 실시간 인기 검색어"),
            HotKeyword(rank: 9, text: "HOT 실검 순위"),
            HotKeyword(rank: 10, text: "최신 인기 검색어"),
            HotKeyword(rank: 11, text: "실검 HOT"),
            HotKeyword(rank: 12, text: "실시간 인기 검색어 HOT"),
            HotKeyword(rank: 13, text: "대한민국 실시간 인기 검색어 HOT"),
            HotKeyword(rank: 14, text: "최근 검색어"),
            HotKeyword(rank: 15, text: "HOT 최신 인기 검색어"),
            HotKeyword(rank: 16, text: "손흥민"),
            HotKeyword(rank: 17, text: "HOTHOTHOT"),
            HotKeyword(rank: 18, text: "토트넘"),
            HotKeyword(rank: 19, text: "김종국"),
            HotKeyword(rank: 20, text: "실검실검실검"),
        ]
        #else
        [
            HotKeyword(rank: 1, text: "****"),
            HotKeyword(rank: 2, text: "****"),
            HotKeyword(rank: 3, text: "***"),
            HotKeyword(rank: 4, text: "***"),
            HotKeyword(rank: 5, text: "***"),
            HotKeyword(rank: 6, text: "********"),
            HotKeyword(rank: 7, text: "*********"),
            HotKeyword(rank: 8, text: "***"),
            HotKeyword(rank: 9, text: "*****"),
            HotKeyword(rank: 10, text: "*****"),
            HotKeyword(rank: 11, text: "******"),
            HotKeyword(rank: 12, text: "***"),
            HotKeyword(rank: 13, text: "****"),
            HotKeyword(rank: 14, text: "*****"),
            HotKeyword(rank: 15, text: "***********"),
            HotKeyword(rank: 16, text: "***"),
            HotKeyword(rank: 17, text: "*******"),
            HotKeyword(rank: 18, text: "***"),
            HotKeyword(rank: 19, text: "***"),
            HotKeyword(rank: 20, text: "*********"),
        ]
        #endif
    }
}


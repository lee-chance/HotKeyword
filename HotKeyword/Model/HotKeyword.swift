//
//  HotKeyword.swift
//  HotKeyword
//
//  Created by 이창수 on 2022/05/04.
//

import SwiftUI

struct HotKeyword: Identifiable {
    let rank: Int
    let latestRank: Int
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
    
    enum Variation {
        case increase, decrease, same
        
        var isIncrease: Bool {
            self == .increase
        }
        
        var isDecrease: Bool {
            self == .decrease
        }
        
        var isSame: Bool {
            self == .same
        }
    }
    
    var variation: Variation {
        if rank < latestRank { return .increase }
        if rank > latestRank { return .decrease }
        return .same
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
            HotKeyword(rank: 1, latestRank: 1, text: "HOT"),
            HotKeyword(rank: 2, latestRank: 1, text: "실시간 인기 검색어"),
            HotKeyword(rank: 3, latestRank: 1, text: "실검"),
            HotKeyword(rank: 4, latestRank: 1, text: "실검순위"),
            HotKeyword(rank: 5, latestRank: 1, text: "HOT 실검"),
            HotKeyword(rank: 6, latestRank: 1, text: "HOT 실시간 인기 검색어"),
            HotKeyword(rank: 7, latestRank: 1, text: "대한민국 실검"),
            HotKeyword(rank: 8, latestRank: 1, text: "대한민국 실시간 인기 검색어"),
            HotKeyword(rank: 9, latestRank: 1, text: "HOT 실검 순위"),
            HotKeyword(rank: 10, latestRank: 1, text: "최신 인기 검색어"),
            HotKeyword(rank: 11, latestRank: 1, text: "실검 HOT"),
            HotKeyword(rank: 12, latestRank: 1, text: "실시간 인기 검색어 HOT"),
            HotKeyword(rank: 13, latestRank: 1, text: "대한민국 실시간 인기 검색어 HOT"),
            HotKeyword(rank: 14, latestRank: 1, text: "최근 검색어"),
            HotKeyword(rank: 15, latestRank: 1, text: "HOT 최신 인기 검색어"),
            HotKeyword(rank: 16, latestRank: 1, text: "손흥민"),
            HotKeyword(rank: 17, latestRank: 1, text: "HOTHOTHOT"),
            HotKeyword(rank: 18, latestRank: 1, text: "토트넘"),
            HotKeyword(rank: 19, latestRank: 1, text: "김종국"),
            HotKeyword(rank: 20, latestRank: 1, text: "실검실검실검"),
        ]
        #else
        [
            HotKeyword(rank: 1, latestRank: 1, text: "****"),
            HotKeyword(rank: 2, latestRank: 1, text: "****"),
            HotKeyword(rank: 3, latestRank: 1, text: "***"),
            HotKeyword(rank: 4, latestRank: 1, text: "***"),
            HotKeyword(rank: 5, latestRank: 1, text: "***"),
            HotKeyword(rank: 6, latestRank: 1, text: "********"),
            HotKeyword(rank: 7, latestRank: 1, text: "*********"),
            HotKeyword(rank: 8, latestRank: 1, text: "***"),
            HotKeyword(rank: 9, latestRank: 1, text: "*****"),
            HotKeyword(rank: 10, latestRank: 1, text: "*****"),
            HotKeyword(rank: 11, latestRank: 1, text: "******"),
            HotKeyword(rank: 12, latestRank: 1, text: "***"),
            HotKeyword(rank: 13, latestRank: 1, text: "****"),
            HotKeyword(rank: 14, latestRank: 1, text: "*****"),
            HotKeyword(rank: 15, latestRank: 1, text: "***********"),
            HotKeyword(rank: 16, latestRank: 1, text: "***"),
            HotKeyword(rank: 17, latestRank: 1, text: "*******"),
            HotKeyword(rank: 18, latestRank: 1, text: "***"),
            HotKeyword(rank: 19, latestRank: 1, text: "***"),
            HotKeyword(rank: 20, latestRank: 1, text: "*********"),
        ]
        #endif
    }
}


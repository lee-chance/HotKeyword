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

#if DEBUG
extension HotKeyword {
    static func dummy() -> [HotKeyword] {
        [
            HotKeyword(rank: 1, text: "르세라핌"),
            HotKeyword(rank: 2, text: "붉은단심"),
            HotKeyword(rank: 3, text: "아이유"),
            HotKeyword(rank: 4, text: "손흥민"),
            HotKeyword(rank: 5, text: "이은해"),
            HotKeyword(rank: 6, text: "1차전 전희철 감독"),
            HotKeyword(rank: 7, text: "오후 4만 9507명"),
            HotKeyword(rank: 8, text: "에스파"),
            HotKeyword(rank: 9, text: "우크라이나"),
            HotKeyword(rank: 10, text: "마스크 해제"),
            HotKeyword(rank: 11, text: "사랑의 꽈배기"),
            HotKeyword(rank: 12, text: "유재석"),
            HotKeyword(rank: 13, text: "붉은 단심"),
            HotKeyword(rank: 14, text: "태종 이방원"),
            HotKeyword(rank: 15, text: "결혼작사 이혼작곡 시즌3"),
            HotKeyword(rank: 16, text: "설인아"),
            HotKeyword(rank: 17, text: "우리들의 블루스"),
            HotKeyword(rank: 18, text: "토트넘"),
            HotKeyword(rank: 19, text: "김종국"),
            HotKeyword(rank: 20, text: "사장님 귀는 당나귀 귀"),
        ]
    }
}
#endif

//
//  KeywordWidget.swift
//  KeywordWidget
//
//  Created by 이창수 on 2022/05/04.
//

import WidgetKit
import SwiftUI

struct SingleKeywordWidget: Widget {
    let kind: String = "com.cslee.HotKeyword.SingleKeywordWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            SingleKeywordWidgetView(entry: entry)
        }
        .configurationDisplayName("🔥 실시간 인기 검색어")
        .description("현재 인기 검색어를 빠르게 볼 수 있습니다!")
        .supportedFamilies([.systemSmall])
    }
}

struct MultipleKeywordWidget: Widget {
    let kind: String = "com.cslee.HotKeyword.MultipleKeywordWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MultipleKeywordWidgetView(entry: entry)
        }
        .configurationDisplayName("🔥 실시간 인기 검색어")
        .description("현재 인기 검색어를 빠르게 볼 수 있습니다!")
        .supportedFamilies([.systemSmall])
    }
}

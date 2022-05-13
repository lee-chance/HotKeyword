//
//  KeywordWidget.swift
//  KeywordWidget
//
//  Created by 이창수 on 2022/05/04.
//

import WidgetKit
import SwiftUI
import Firebase

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), keywords: HotKeyword.dummy(), updatedAt: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let currentDate = Date()
        
        // 이거 이렇게 하면 안되고 파이에베이스에서 가져와야댄다~~
        if let userDefaults = UserDefaults(suiteName: "group.com.cslee.HotKeyword") {
            let savedKeywords = userDefaults.object(forKey: "keywords") as? Data ?? Data()
            let updatedDate = userDefaults.object(forKey: "updatedDate") as? Date ?? Date()
            let keywords = (try? PropertyListDecoder().decode([HotKeyword].self, from: savedKeywords)) ?? [HotKeyword(rank: 1, text: "오류오류ㅜ")]
            
            let newEntry = SimpleEntry(date: currentDate + 1, keywords: keywords, updatedAt: updatedDate)
            completion(newEntry)
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        getSnapshot(in: context) { entry in
            let defaultEntry = SimpleEntry(date: entry.date - 1, keywords: entry.keywords, updatedAt: entry.updatedAt)
            
            let timeline = Timeline(entries: [defaultEntry, entry], policy: .atEnd)
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let keywords: [HotKeyword]
    let updatedAt: Date
}

struct KeywordWidgetEntryView : View {
    @Environment(\.widgetFamily) var family: WidgetFamily // TODO: 이거로 분기 처리하기~
    var entry: Provider.Entry

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Circle()
                    .frame(width: 36, height: 36)
                    .overlay(
                        Text("🔥")
                    )
                
                Text(entry.updatedAt, style: .time)
                    .font(.footnote)
                
                Text("실시간 인기 검색어")
                    .font(.callout)
            }
            .frame(maxWidth: .infinity)
            
            let keyword = entry.keywords.first!
            Text(keyword.text)
                .fontWeight(.bold)
                .padding(.vertical, 4)
                .frame(maxWidth: .infinity)
                .background(
                    Color.gold
                        .cornerRadius(8)
                )
        }
        .padding(.horizontal, 8)
    }
}

@main
struct KeywordWidget: Widget {
    let kind: String = "com.cslee.HotKeyword.KeywordWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            KeywordWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("🔥 실시간 인기 검색어")
        .description("This is an example widget.")
    }
}

struct KeywordWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            KeywordWidgetEntryView(entry: SimpleEntry(date: Date(), keywords: HotKeyword.dummy(), updatedAt: Date()))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            
//            KeywordWidgetEntryView(entry: SimpleEntry(date: Date()))
//                .previewContext(WidgetPreviewContext(family: .systemMedium))
            
//            KeywordWidgetEntryView(entry: SimpleEntry(date: Date()))
//                .previewContext(WidgetPreviewContext(family: .systemLarge))
            
//            KeywordWidgetEntryView(entry: SimpleEntry(date: Date()))
//                .previewContext(WidgetPreviewContext(family: .systemExtraLarge))
        }
    }
}

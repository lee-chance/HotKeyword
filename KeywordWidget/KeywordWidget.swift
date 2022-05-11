//
//  KeywordWidget.swift
//  KeywordWidget
//
//  Created by 이창수 on 2022/05/04.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let keywords: [HotKeyword] = HotKeyword.dummy()
    let updatedAt: Date = Date()
}

struct KeywordWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Circle()
                    .frame(width: 36, height: 36)
                    .overlay(
                        Text("🔥")d
                    )
                
                Text(entry.updatedAt, style: .time)
                    .font(.footnote)
                
                Text("실시간 인기 검색어")
                    .font(.callout)
            }
            
            let keyword = entry.keywords.first!
            KeywordRow(keyword: keyword)
        }
    }
}

@main
struct KeywordWidget: Widget {
    let kind: String = "com.cslee.HotKeyword.KeywordWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            KeywordWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct KeywordWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            KeywordWidgetEntryView(entry: SimpleEntry(date: Date()))
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

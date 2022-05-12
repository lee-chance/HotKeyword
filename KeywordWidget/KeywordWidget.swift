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
        let currentDate = Date()
        let group = DispatchGroup()
        
        DispatchQueue.main.async(group: group) {
            group.enter()
            
            let entry = SimpleEntry(date: currentDate)
            entries.append(entry)
            
            // TODO: 대충 네크워크 타는 곳
//            network.getImage(url: "https://picsum.photos/300/300") { result in
//                switch result {
//                case .success(let data):
//                    let entry = SimpleEntry(date: currentDate + 1, imageData: data)
//                    entries.append(entry)
//                    group.leave()
//                case .failure(_):
//                    let entry = SimpleEntry(date: currentDate + 1, imageData: Data())
//                    entries.append(entry)
//                    group.leave()
//                }
//            }
        }
        
        group.notify(queue: .main) {
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let keywords: [HotKeyword] = HotKeyword.dummy()
    let updatedAt: Date = Date()
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

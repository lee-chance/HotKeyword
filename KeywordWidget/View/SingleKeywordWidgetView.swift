//
//  SingleKeywordWidgetView.swift
//  HotKeyword
//
//  Created by 이창수 on 2022/05/20.
//

import SwiftUI
import WidgetKit

struct SingleKeywordWidgetView: View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    let entry: Provider.Entry
    
    var body: some View {
        switch family {
        case .systemSmall:
            SmallView(entry: entry)
        case .systemMedium:
            MediumView(entry: entry)
        case .systemLarge:
            LargeView(entry: entry)
        case .systemExtraLarge:
            ExtraLargeView(entry: entry) // only iPad
        @unknown default:
            Text("unknown")
        }
    }
}

struct SingleKeywordWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleEntry = SimpleEntry(date: Date(), keywords: HotKeyword.dummy(), updatedAt: Date())

        Group {
            SingleKeywordWidgetView.SmallView(entry: sampleEntry)
                .previewContext(WidgetPreviewContext(family: .systemSmall))

            SingleKeywordWidgetView.MediumView(entry: sampleEntry)
                .previewContext(WidgetPreviewContext(family: .systemMedium))

            SingleKeywordWidgetView.LargeView(entry: sampleEntry)
                .previewContext(WidgetPreviewContext(family: .systemLarge))

            if #available(iOSApplicationExtension 15.0, *) {
                SingleKeywordWidgetView.ExtraLargeView(entry: sampleEntry)
                    .previewContext(WidgetPreviewContext(family: .systemExtraLarge))
            } else {
                // Fallback on earlier versions
            }
        }
    }
}

extension SingleKeywordWidgetView {
    struct SmallView: View {
        let entry: Provider.Entry
        
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
                .frame(maxWidth: .infinity, alignment: .leading)
                
                let keyword = entry.keywords.first!
                
                HStack {
                    Text("\(keyword.rank)")
                        .foregroundColor(.text)
                        .frame(width: 32, height: 32)
                        .background(
                            Rectangle()
                                .background(Color.gray.opacity(0.3))
                                .cornerRadius(8)
                        )
                    
                    HStack {
                        Text(keyword.text)
                            .foregroundColor(.text)
                    }
                    .frame(height: 32)
                    .frame(maxWidth: .infinity)
                    .background(
                        Color.gold
                            .cornerRadius(8)
                    )
                }
                .foregroundColor(.clear)
                
//                KeywordRow(keyword: keyword)
//                    .padding(.vertical, 4)
//                    .background(
//                        Color.gold
//                            .cornerRadius(8)
//                    )
//                Text(keyword.text)
//                    .fontWeight(.bold)
//                    .padding(.vertical, 4)
//                    .frame(maxWidth: .infinity)
//                    .background(
//                        Color.gray
//                            .cornerRadius(8)
//                            .overlay(
//                                Text("4")
//                                    .foregroundColor(.text)
//                                    .frame(width: 32, height: 32)
//                                    .background(
//                                        Rectangle()
//                                            .background(Color.gray.opacity(0.3))
//                                            .cornerRadius(8)
//                                    )
//                            )
//                    )
            }
            .padding(.horizontal, 8)
        }
    }

    struct MediumView: View {
        let entry: Provider.Entry
        
        var body: some View {
            EmptyView()
        }
    }

    struct LargeView: View {
        let entry: Provider.Entry
        
        var body: some View {
            EmptyView()
        }
    }

    struct ExtraLargeView: View {
        let entry: Provider.Entry
        
        var body: some View {
            EmptyView()
        }
    }
}

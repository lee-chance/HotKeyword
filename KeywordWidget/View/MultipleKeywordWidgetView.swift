//
//  MultipleKeywordWidgetView.swift
//  KeywordWidgetExtension
//
//  Created by Changsu Lee on 2022/05/21.
//

import SwiftUI
import WidgetKit

struct MultipleKeywordWidgetView: View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    let entry: Provider.Entry
    
    var body: some View {
        SmallView(entry: entry)
//        switch family {
//        case .systemSmall:
//            SmallView(entry: entry)
//        case .systemMedium:
//            MediumView(entry: entry)
//        case .systemLarge:
//            LargeView(entry: entry)
//        case .systemExtraLarge:
//            ExtraLargeView(entry: entry) // only iPad
//        @unknown default:
//            Text("unknown")
//        }
    }
}

//struct MultipleKeywordWidgetView_Previews: PreviewProvider {
//    static var previews: some View {
//        let sampleEntry = SimpleEntry(date: Date(), keywords: HotKeyword.dummy(), updatedAt: Date())
//
//        Group {
//            MultipleKeywordWidgetView.SmallView(entry: sampleEntry)
//                .previewContext(WidgetPreviewContext(family: .systemSmall))
//
//            MultipleKeywordWidgetView.MediumView(entry: sampleEntry)
//                .previewContext(WidgetPreviewContext(family: .systemMedium))
//
//            MultipleKeywordWidgetView.LargeView(entry: sampleEntry)
//                .previewContext(WidgetPreviewContext(family: .systemLarge))
//
//            if #available(iOSApplicationExtension 15.0, *) {
//                MultipleKeywordWidgetView.ExtraLargeView(entry: sampleEntry)
//                    .previewContext(WidgetPreviewContext(family: .systemExtraLarge))
//            } else {
//                // Fallback on earlier versions
//            }
//        }
//    }
//}

// TODO: 버튼 클릭 이벤트, 순위분기처리하기~~
extension MultipleKeywordWidgetView {
    struct SmallView: View {
        let entry: Provider.Entry
        
        var body: some View {
            VStack(spacing: 8) {
                UpdatedDateText(updatedDate: entry.updatedAt)
                
                ForEach(entry.keywords.prefix(3)) { keyword in
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
                                .minimumScaleFactor(0.1)
                        }
                        .frame(height: 32)
                        .frame(maxWidth: .infinity)
                        .background(
                            keyword.backgroundColor
                                .opacity(0.5)
                                .cornerRadius(8)
                        )
                    }
                    .foregroundColor(.clear)
                }
            }
            .padding(8)
            .frame(maxWidth: .infinity, maxHeight: .infinity) // 상하단 여백을 없애기 위해 반드시 필요!
            .background(
                LinearGradient(colors: [.red, .yellow], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .opacity(0.6)
            )
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
            SmallView(entry: entry)
        }
    }

    struct ExtraLargeView: View {
        let entry: Provider.Entry
        
        var body: some View {
            EmptyView()
        }
    }
}

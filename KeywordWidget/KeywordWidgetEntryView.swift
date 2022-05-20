//
//  KeywordWidgetEntryView.swift
//  HotKeyword
//
//  Created by 이창수 on 2022/05/20.
//

import SwiftUI
import WidgetKit

struct KeywordWidgetEntryView: View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    let entry: Provider.Entry
    
    var body: some View {
        switch family {
        case .systemSmall:      SmallView(entry: entry)
        case .systemMedium:     MediumView(entry: entry)
        case .systemLarge:      LargeView(entry: entry)
        case .systemExtraLarge: ExtraLargeView(entry: entry) // only iPad
        @unknown default:       Text("unknown")
        }
    }
}

extension KeywordWidgetEntryView {
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

//
//  Provider.swift
//  KeywordWidgetExtension
//
//  Created by 이창수 on 2022/05/20.
//

import WidgetKit
import Firebase

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), keywords: HotKeyword.dummy(), updatedAt: Date(), context: context)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let db = Firestore.firestore()
        
        db.collection("keywords").document("finalKeywords")
            .getDocument { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    return
                }
                
                guard
                    let lastUpdatedAt = document.get("timestamp") as? Timestamp,
                    let keywords = document.get("keywords") as? [String]
                else {
                    return
                }
                
                let hotKeywords = keywords.indices.map { HotKeyword(rank: $0 + 1, text: keywords[$0]) }
                
                let entry = SimpleEntry(date: Date() + 1, keywords: hotKeywords, updatedAt: lastUpdatedAt.dateValue(), context: context)
                completion(entry)
            }
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        getSnapshot(in: context) { entry in
            let defaultEntry = SimpleEntry(date: entry.date - 1, keywords: entry.keywords, updatedAt: entry.updatedAt, context: entry.context)
            
            let timeline = Timeline(entries: [defaultEntry, entry], policy: .atEnd)
            completion(timeline)
        }
    }
}

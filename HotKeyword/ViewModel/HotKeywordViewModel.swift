//
//  HotKeywordViewModel.swift
//  HotKeyword
//
//  Created by 이창수 on 2022/05/04.
//

import SwiftUI
import Firebase

final class HotKeywordViewModel: ObservableObject {
    @Published private(set) var model = HotKeywordModel() {
        didSet {
            if let userDefaults = UserDefaults(suiteName: "group.com.cslee.HotKeyword") {
                userDefaults.set(try? PropertyListEncoder().encode(model.keywords), forKey: "keywords")
                userDefaults.set(model.updatedDate, forKey: "updatedDate")
            }
        }
    }
    
    var keywords: [HotKeyword] {
        model.keywords
    }
    
    var updatedDate: Date {
        model.updatedDate
    }
    
    let db: Firestore
    
    init() {
        db = Firestore.firestore()
    }
    
    func hotKeywordBinding() {
        db.collection("keywords").document("finalKeywords")
            .addSnapshotListener { [weak self] documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                
                guard
                    let lastUpdatedAt = document.get("timestamp") as? Timestamp,
                    let keywords = document.get("keywords") as? [String]
                else {
                    print("Document data was empty.")
                    return
                }
                
                let hotKeywords = keywords.indices.map { HotKeyword(rank: $0 + 1, text: keywords[$0]) }
                
                let model = HotKeywordModel(keywords: hotKeywords, updatedDate: lastUpdatedAt.dateValue())
                
                withAnimation {
                    self?.model = model
                }
            }
    }
}

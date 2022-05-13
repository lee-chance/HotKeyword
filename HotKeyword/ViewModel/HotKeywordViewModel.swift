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
        db.collection("common").document("timestamp")
            .addSnapshotListener { [weak self] documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                
                guard let lastUpdatedAt = document.get("lastUpdatedAt") as? Timestamp else {
                    print("Document data was empty.")
                    return
                }
                
                let finalKeywordsQuery = self?.db.collection("finalKeywords").order(by: "point", descending: true).limit(to: 20)
                finalKeywordsQuery?.getDocuments { querySnapshot, err in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        var tempKeywords = [HotKeyword]()
                        
                        for (index, document) in querySnapshot!.documents.enumerated() {
                            let hotKeyword = HotKeyword(rank: index + 1, text: document.documentID)
                            tempKeywords.append(hotKeyword)
                        }
                        
                        let model = HotKeywordModel(keywords: tempKeywords, updatedDate: lastUpdatedAt.dateValue())
                        self?.model = model
                    }
                }
            }
    }
}

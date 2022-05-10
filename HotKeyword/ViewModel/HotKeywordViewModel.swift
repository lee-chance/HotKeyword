//
//  HotKeywordViewModel.swift
//  HotKeyword
//
//  Created by 이창수 on 2022/05/04.
//

import SwiftUI
import Firebase

final class HotKeywordViewModel: ObservableObject {
    @Published var keywords: [HotKeyword] = HotKeyword.dummy()
    @Published var updatedDate: Date = Date()
    
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
                        
                        withAnimation {
                            self?.keywords = tempKeywords
                        }
                        self?.updatedDate = lastUpdatedAt.dateValue()
                    }
                }
            }
    }
}

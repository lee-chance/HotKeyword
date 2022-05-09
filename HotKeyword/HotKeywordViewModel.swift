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
        db.collection("keywords").document("finalKeywords")
            .addSnapshotListener { [weak self] documentSnapshot, error in
                guard let self = self else { return }
                
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                
                guard
                    let serverKeywords = document.get("keywords") as? [String],
                    let serverUpdatedDate = document.get("timestamp") as? Timestamp
                        
                else {
                    print("Document data was empty.")
                    return
                }
                
                let updatedKeywords = serverKeywords.indices.map { HotKeyword(rank: $0 + 1, text: serverKeywords[$0]) }
                
                withAnimation {
                    self.keywords = updatedKeywords
                }
                self.updatedDate = serverUpdatedDate.dateValue()
            }
    }
}

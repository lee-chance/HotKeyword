//
//  HotKeywordViewModelOnlyApp.swift
//  HotKeyword
//
//  Created by 이창수 on 2022/05/04.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift


// MARK: - Hot Keyword

fileprivate typealias InternalKeywords = [String : InternalKeywordValue]

extension HotKeywordViewModel {
    func search(keyword: String, from engine: SearchEngine) {
        let searchingURLString = engine.urlString + keyword
        let encodedString = searchingURLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        if let url = URL(string: encodedString) {
            UIApplication.shared.open(url, options: [:]) { [weak self] opened in
                if opened {
                    self?.addCount(keyword: keyword)
                } else {
                    Logger.error("오류 발생: \(searchingURLString)")
                }
            }
        } else {
            Logger.error("오류 발생: \(searchingURLString)")
        }
    }
    
    private func addCount(keyword: String) {
        loadInternalKeywords { [weak self] datas in
            self?.addCountInternalKeyword(keywords: datas, keyword: keyword)
        }
    }
    
    private func loadInternalKeywords(completion: @escaping (InternalKeywords?) -> Void) {
        db.collection("internalKeywords")
            .getDocuments { querySnapshot, err in
                if let err = err {
                    Logger.error("Error getting documents: \(err)")
                } else {
                    var tempKeywords = InternalKeywords()
                    
                    for document in querySnapshot!.documents {
                        if let point = document.data()["point"] as? Double,
                           let updatedAt = document.data()["updatedAt"] as? Timestamp {
                            tempKeywords[document.documentID] = InternalKeywordValue(point: point, updatedAt: updatedAt.dateValue())
                        } else {
                        }
                    }
                    
                    completion(tempKeywords.keys.count > 0 ? tempKeywords : nil)
                }
            }
    }
    
    private func addCountInternalKeyword(keywords: InternalKeywords?, keyword: String) {
        let updatedKeyword: InternalKeywordValue
        let pointPerClick = AppSettings.shared.pointPerClick
        
        if let keywords = keywords {
            if keywords.keys.contains(keyword) {
                let point = keywords[keyword]!.point
                updatedKeyword = InternalKeywordValue(point: point + pointPerClick, updatedAt: Timestamp().dateValue())
            } else {
                updatedKeyword = InternalKeywordValue(point: pointPerClick, updatedAt: Timestamp().dateValue())
            }
        } else {
            updatedKeyword = InternalKeywordValue(point: pointPerClick, updatedAt: Timestamp().dateValue())
        }
        
        do {
            try db.collection("internalKeywords").document(keyword).setData(from: updatedKeyword)
        } catch let error {
            Logger.error("Error writing to Firestore: \(error)")
        }
    }
}


// MARK: - Hot News

extension HotKeywordViewModel {
    func openNews(url: URL?) {
        guard let url = url else {
            Logger.error("오류 발생 url is nil")
            return
        }
        
        UIApplication.shared.open(url, options: [:]) { opened in
            guard opened else {
                Logger.error("오류 발생: \(url)")
                return
            }
        }
    }
}

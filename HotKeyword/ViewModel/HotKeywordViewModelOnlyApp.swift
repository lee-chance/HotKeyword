//
//  HotKeywordViewModelOnlyApp.swift
//  HotKeyword
//
//  Created by 이창수 on 2022/05/04.
//

import UIKit
import Firebase

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
                    print("오류 발생: \(searchingURLString)")
                }
            }
        } else {
            print("오류 발생: \(searchingURLString)")
        }
    }
    
    private func addCount(keyword: String) {
        loadInternalKeywords { [weak self] datas in
            self?.addCountInternalKeyword(keywords: datas, keyword: keyword)
        }
    }
    
    private func loadInternalKeywords(completion: @escaping (InternalKeywords?) -> Void) {
        db.collection("keywords").document("internalKeywords")
            .getDocument { document, error in
                guard
                    let document = document,
                    document.exists,
                    let datas = document.data() as? InternalKeywords
                else {
                    completion(nil)
                    return
                }
                
                completion(datas.keys.count > 0 ? datas : nil)
            }
    }
    
    private func addCountInternalKeyword(keywords: InternalKeywords?, keyword: String) {
        var updatedKeywords: InternalKeywords
        if let keywords = keywords {
            updatedKeywords = keywords
            
            if keywords.keys.contains(keyword) {
                let point = updatedKeywords[keyword]!.point
                let newInternalKeyword = InternalKeywordValue(point: point + 0.1, updatedAt: Timestamp().dateValue())
                updatedKeywords[keyword] = newInternalKeyword
            } else {
                let newInternalKeyword = InternalKeywordValue(point: 0.1, updatedAt: Timestamp().dateValue())
                updatedKeywords[keyword] = newInternalKeyword
            }
        } else {
            updatedKeywords = [keyword : InternalKeywordValue(point: 0.1, updatedAt: Timestamp().dateValue())]
        }
        
        db.collection("keywords").document("internalKeywords").setData(updatedKeywords) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
}

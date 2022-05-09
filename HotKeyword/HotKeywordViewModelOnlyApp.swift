//
//  HotKeywordViewModelOnlyApp.swift
//  HotKeyword
//
//  Created by 이창수 on 2022/05/04.
//

import UIKit

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
            if let datas = datas {
                self?.addCountInternalKeyword(keywords: datas, keyword: keyword)
            } else {
                print("Document does not exist")
            }
        }
    }
    
    private func loadInternalKeywords(completion: @escaping ([String : Double]?) -> Void) {
        db.collection("keywords").document("internalKeywords")
            .getDocument { document, error in
                guard
                    let document = document,
                    document.exists,
                    let datas = document.data() as? [String : Double]
                else {
                    completion(nil)
                    return
                }
                
                completion(datas)
            }
    }
    
    private func addCountInternalKeyword(keywords: [String : Double], keyword: String) {
        var updatedKeywords = keywords
        
        if keywords.keys.contains(keyword) {
            updatedKeywords[keyword]! += 0.1
        } else {
            updatedKeywords[keyword] = 0.1
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

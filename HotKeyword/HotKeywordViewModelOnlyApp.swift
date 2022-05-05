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
            UIApplication.shared.open(url, options: [:]) { bool in
                // TODO: 여기서 Firebase 추가하기이
                print("opened: \(bool)")
            }
        } else {
            print("오류 발생: \(searchingURLString)")
        }
    }
}

//
//  HotKeywordInfo.swift
//  HotKeyword
//
//  Created by 이창수 on 2022/05/20.
//

import Foundation

struct HotKeywordInfo {
    static var appVersion: String? {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
}

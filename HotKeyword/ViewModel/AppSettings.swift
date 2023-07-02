//
//  AppSettings.swift
//  HotKeyword
//
//  Created by 이창수 on 2022/05/04.
//

import SwiftUI

final class AppSettings: ObservableObject {
    static let shared = AppSettings()
    
    @AppStorage(AppStorageKey.searchEngine.key) var searchEngine: SearchEngine = .naver
    
    private(set) var pointPerClick: CGFloat = 0
    
    private(set) var adFree: Bool = true
    
    func setPointPerClick(point: CGFloat) {
        pointPerClick = point
    }
}

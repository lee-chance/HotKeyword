//
//  AppSettings.swift
//  HotKeyword
//
//  Created by 이창수 on 2022/05/04.
//

import Foundation
import CoreGraphics

final class AppSettings: ObservableObject {
    static let shared = AppSettings()
    
    private(set) var searchEngine: SearchEngine = .google
    
    private(set) var pointPerClick: CGFloat = 0
    
    private init() {
        fetchSearchEngine()
    }
    
    private func saveSearchEngine(_ engine: SearchEngine) {
        UserDefaults.standard.set(engine.rawValue, forKey: UserDefaultsKey.searchEngine.key)
    }
    
    private func fetchSearchEngine() {
        if let savedSearchEngine = UserDefaults.standard.string(forKey: UserDefaultsKey.searchEngine.key),
           let engine = SearchEngine(rawValue: savedSearchEngine) {
            searchEngine = engine
        }
    }
    
    func setPointPerClick(point: CGFloat) {
        pointPerClick = point
    }
    
    func setSearchEngine(_ engine: SearchEngine) {
        searchEngine = engine
        saveSearchEngine(engine)
    }
}

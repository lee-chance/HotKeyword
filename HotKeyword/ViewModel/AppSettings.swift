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
    
    private(set) var searchEngine: SearchEngine = .naver
    
    private(set) var pointPerClick: CGFloat = 0
    
    private(set) var adFree: Bool = true
    
    @Published var allowsNotification: Bool = false {
        didSet {
            notification(isOn: allowsNotification) { [weak self] _ in
                DispatchQueue.main.async {
                    self?.allowsNotification = oldValue
                }
            }
        }
    }
    
    private init() {
        fetchSearchEngine()
        fetchAllowsNotification()
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
    
    private func saveAllowsNotification(_ isOn: Bool) {
        UserDefaults.standard.set(isOn, forKey: UserDefaultsKey.allowsNotification.key)
    }
    
    private func fetchAllowsNotification() {
        allowsNotification = UserDefaults.standard.bool(forKey: UserDefaultsKey.allowsNotification.key)
    }
    
    private func notification(isOn: Bool, failure: @escaping (Error) -> Void) {
        saveAllowsNotification(isOn)
        
        if isOn {
            FCMManager.subscribe(topic: .hotKeyword(clock: 9), failure: failure)
        } else {
            FCMManager.unsubscribe(topic: .hotKeyword(clock: 9), failure: failure)
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

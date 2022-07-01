//
//  HotKeywordViewModel.swift
//  HotKeyword
//
//  Created by 이창수 on 2022/05/04.
//

import SwiftUI
import Firebase

enum MainTab {
    case keyword, news
    
    var name: String {
        switch self {
        case .keyword: return "검색어"
        case .news: return "뉴스"
        }
    }
}

final class HotKeywordViewModel: ObservableObject {
    
    @Published var tabSelection: MainTab = .keyword
    
    @Published private(set) var model = HotKeywordModel() {
        didSet {
            // FIXME: 이거 필요 없어보인다..
//            if let userDefaults = UserDefaults(suiteName: "group.com.cslee.HotKeyword") {
//                userDefaults.set(try? PropertyListEncoder().encode(model.keywords), forKey: "keywords")
//                userDefaults.set(model.updatedDate, forKey: "updatedDate")
//            }
        }
    }
    
    @Published private(set) var news = [Article]()
    
    
    // MARK: - UI
    var navigationTitle: String {
        return "🔥 실시간 인기 \(tabSelection.name)"
    }
    
    var keywords: [HotKeyword] {
        model.keywords
    }
    
    var updatedDate: Date {
        model.updatedDate
    }
    
    var bottomBannerHeight: CGFloat {
        if AppSettings.shared.adFree {
            return 0
        } else {
            return Screen.height > 600 ? 100 : 50
        }
    }
    
    let db: Firestore
    
    init() {
        db = Firestore.firestore()
    }
    
    func hotKeywordBinding() {
        db.collection(HotValue.hotKeywordsCollectionName.rawValue).document("finalKeywords")
            .addSnapshotListener { [weak self] documentSnapshot, error in
                guard let document = documentSnapshot else {
                    Logger.error("Error fetching document: \(error!)")
                    return
                }
                
                guard
                    let lastUpdatedAt = document.get("timestamp") as? Timestamp,
                    let firebaseKeywords = document.get("keywords") as? [String]
                else {
                    Logger.error("Document data was empty.")
                    return
                }
                
                let keywords = firebaseKeywords.map { $0.components(separatedBy: " | ") }
                
                let hotKeywords = keywords.map { HotKeyword(rank: Int($0[1])!, latestRank: Int($0[2])!, text: $0[0]) }
                
                let model = HotKeywordModel(keywords: hotKeywords, updatedDate: lastUpdatedAt.dateValue())
                
                withAnimation {
                    self?.model = model
                }
            }
    }
    
    func hotNewsBinding() {
        db.collection(HotValue.hotNewsCollectionName.rawValue).document("headlines")
            .addSnapshotListener { [weak self] documentSnapshot, error in
                guard let document = documentSnapshot else {
                    Logger.error("Error fetching document: \(error!)")
                    return
                }
                
                guard
                    let jsonData = try? JSONSerialization.data(withJSONObject: document.get("articles")!, options: []),
                    let articles = try? JSONDecoder().decode([ArticleResponse].self, from: jsonData)
                else {
                    Logger.error("Document data was empty.")
                    return
                }
                
                withAnimation {
                    self?.news = articles.compactMap { $0.toArticle() }
                }
            }
    }
}

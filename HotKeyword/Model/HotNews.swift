//
//  HotNews.swift
//  HotKeyword
//
//  Created by Changsu Lee on 2022/06/24.
//

import Foundation

struct ArticleResponse: Codable {
    let title: String?
    let description: String?
    let urlString: String?
    let imageURLString: String?
    let publishedAtString: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case urlString = "url"
        case imageURLString = "urlToImage"
        case publishedAtString = "publishedAt"
    }
    
    func toArticle() -> Article? {
        guard
            let title = title,
            let urlString = urlString,
            let publishedAtString = publishedAtString
        else {
            print("cslog failed to article(): \(self)")
            return nil
        }
        
        return Article(title: title, description: description, urlString: urlString, imageURLString: imageURLString, publishedAtString: publishedAtString)
    }
}

struct Article: Identifiable {
    let title: String
    let description: String
    private let urlString: String
    private let imageURLString: String?
    private let publishedAtString: String
    
    init(title: String, description: String?, urlString: String, imageURLString: String?, publishedAtString: String) {
        self.title = title
        self.description = description ?? title
        self.urlString = urlString
        self.imageURLString = imageURLString
        self.publishedAtString = publishedAtString
    }
    
    var url: URL? {
        URL(string: urlString)
    }
    
    var imageURL: URL? {
        URL(string: imageURLString ?? "https://fakeimg.pl/600x400/?text=No%20Image")
    }
    
    var publishedAt: Date {
        // 2022-06-24T06:32:00Z
        publishedAtString.toDate(format: "yyyy-MM-dd'T'HH:mm:ssZ") ?? Date()
    }
    
    var publishedAtFormNow: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateTimeStyle = .named
        
        return formatter.localizedString(for: publishedAt, relativeTo: Date())
    }
    
    var id: String { UUID().uuidString }
}

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
    let publisehdAtString: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case urlString = "url"
        case imageURLString = "urlToImage"
        case publisehdAtString = "publishedAt"
    }
    
    func toArticle() -> Article? {
        guard
            let title = title,
            let description = description,
            let urlString = urlString,
            let imageURLString = imageURLString,
            let publisehdAtString = publisehdAtString
        else {
            print("cslog failed to article(): \(self)")
            return nil
        }
        
        return Article(title: title, description: description, urlString: urlString, imageURLString: imageURLString, publisehdAtString: publisehdAtString)
    }
}

struct Article: Identifiable {
    let title: String
    let description: String
    let urlString: String
    let imageURLString: String
    let publisehdAtString: String
    
    var url: URL? {
        URL(string: urlString)
    }
    
    var imageURL: URL? {
        URL(string: imageURLString)
    }
    
    var id: String { UUID().uuidString }
}

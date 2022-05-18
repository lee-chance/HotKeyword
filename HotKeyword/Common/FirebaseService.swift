//
//  FirebaseService.swift
//  HotKeyword
//
//  Created by 이창수 on 2022/05/18.
//

import Foundation

enum FirebaseService {
    case initialize
}

extension FirebaseService: Service {
    var baseURL: String { "https://realtime-keyword.web.app" }
    
    var path: String {
        switch self {
        case .initialize: return "/api/initialize.json"
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .initialize: return nil
        }
    }
    
    var method: ServiceMethod {
        switch self {
        case .initialize: return .get
        }
    }
}

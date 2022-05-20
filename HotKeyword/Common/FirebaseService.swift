//
//  FirebaseService.swift
//  HotKeyword
//
//  Created by 이창수 on 2022/05/18.
//

import Foundation

enum FirebaseService {
    case initialize
    case versionCheck
}

extension FirebaseService: Service {
    var baseURL: String { "https://realtime-keyword.firebaseapp.com" }
    
    var path: String {
        switch self {
        case .initialize: return "/api/initialize.json"
        case .versionCheck: return "/api/versionCheck.json"
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .initialize: return nil
        case .versionCheck: return nil
        }
    }
    
    var method: ServiceMethod {
        switch self {
        case .initialize: return .get
        case .versionCheck: return .get
        }
    }
}

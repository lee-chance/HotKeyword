//
//  AppInitialize.swift
//  HotKeyword
//
//  Created by 이창수 on 2022/05/18.
//

import Foundation
import CoreGraphics

struct AppInitialize {
    struct Initialize: Codable {
        let pointPerClick: CGFloat
    }
    
    struct VersionCheck: Codable {
        let required: VersionCheckDetail
        let optional: VersionCheckDetail
    }
    
    struct VersionCheckDetail: Codable {
        let version: String
        let title: String
        let message: String
    }
}

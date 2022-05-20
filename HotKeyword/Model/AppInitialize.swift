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
        let requiredVersion: String
        let optionalVersion: String
    }
}

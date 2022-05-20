//
//  Version.swift
//  HotKeyword
//
//  Created by 이창수 on 2022/05/20.
//

import Foundation

struct Version {
    private let major: Int
    private let minor: Int
    private let fetch: Int
    
    init(_ major: Int, _ minor: Int, _ fetch: Int) {
        self.major = major
        self.minor = minor
        self.fetch = fetch
    }
    
    init(major: Int, minor: Int, fetch: Int = 0) {
        self.init(major, minor, fetch)
    }
    
    init(string: String) {
        let splited = string.split(separator: ".").map { Int($0) ?? 0 }
        
        self.init(splited[0], splited[1], splited.count > 2 ? splited[2] : 0)
    }
}

extension Version: Comparable {
    static func < (lhs: Version, rhs: Version) -> Bool {
        if lhs.major < rhs.major {
            return true
        } else if lhs.major > rhs.major {
            return false
        } else {
            if lhs.minor < rhs.minor {
                return true
            } else if lhs.minor > rhs.minor {
                return false
            } else {
                return lhs.fetch < rhs.fetch
            }
        }
    }
}

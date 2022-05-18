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
    private init() {}
    
    private(set) var searchEngine: SearchEngine = .google
    
    private(set) var pointPerClick: CGFloat = 0
    
    func setPointPerClick(point: CGFloat) {
        pointPerClick = point
    }
}

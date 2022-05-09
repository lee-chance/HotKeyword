//
//  AppSettings.swift
//  HotKeyword
//
//  Created by 이창수 on 2022/05/04.
//

import Foundation

final class AppSettings: ObservableObject {
    @Published var searchEngine: SearchEngine = .google
}

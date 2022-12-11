//
//  DataExtension.swift
//  HotKeyword
//
//  Created by Changsu Lee on 2022/12/11.
//

import Foundation

extension Data {
    func jsonPrettyPrint() {
        if let json = try? JSONSerialization.jsonObject(with: self, options: .mutableContainers),
           let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
            print(String(decoding: jsonData, as: UTF8.self))
        } else {
            print("json data malformed")
        }
    }
}

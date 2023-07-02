//
//  DateExtension.swift
//  HotKeyword
//
//  Created by 이창수 on 2022/05/04.
//

import Foundation

extension Date {
    func toString(format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        
        return dateFormatter.string(from: self)
    }
}

extension String {
    func toDate(format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        
        return dateFormatter.date(from: self)
    }
    
    func toStringDate(from: String = "yyyy-MM-dd HH:mm:ss", to: String = "yyyy-MM-dd HH:mm:ss") -> String {
        toDate(format: from)?.toString(format: to) ?? self
    }
}

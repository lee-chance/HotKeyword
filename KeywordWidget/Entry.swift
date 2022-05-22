//
//  Entry.swift
//  HotKeyword
//
//  Created by 이창수 on 2022/05/20.
//

import WidgetKit

struct SimpleEntry: TimelineEntry {
    let date: Date
    let keywords: [HotKeyword]
    let updatedAt: Date
    var context: Provider.Context?
}

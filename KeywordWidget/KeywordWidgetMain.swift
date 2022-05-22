//
//  KeywordWidgetMain.swift
//  KeywordWidgetExtension
//
//  Created by 이창수 on 2022/05/20.
//

import SwiftUI
import Firebase

@main
struct KeywordWidgets: WidgetBundle {
    
    init() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
    }
    
    @WidgetBundleBuilder
    var body: some Widget {
//        SingleKeywordWidget()
        MultipleKeywordWidget()
    }
}

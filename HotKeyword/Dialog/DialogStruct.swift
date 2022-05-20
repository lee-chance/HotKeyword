//
//  DialogStruct.swift
//  HotKeyword
//
//  Created by 이창수 on 2022/05/20.
//

import SwiftUI

extension DialogContent {
    struct NeedUpdateDialog: View {
        let action: () -> Void
        
        var body: some View {
            VStack {
                Text("반드시 업데이트")
                
                Button(action: {
                    action()
                    DialogPresentation.shared.hide()
                }) {
                    Text("업데이트하기!")
                }
            }
            .padding(16)
        }
    }
    
    struct SuggestUpdateDialog: View {
        let dismissAction: () -> Void
        let updateAction: () -> Void
        
        var body: some View {
            VStack {
                Text("업데이트 할래?")
                
                HStack {
                    Button(action: {
                        dismissAction()
                        DialogPresentation.shared.hide()
                    }) {
                        Text("다음에")
                    }
                    
                    Button(action: {
                        updateAction()
                        DialogPresentation.shared.hide()
                    }) {
                        Text("업데이트하기!")
                    }
                }
            }
            .padding(16)
        }
    }
}

//
//  DialogStruct.swift
//  HotKeyword
//
//  Created by 이창수 on 2022/05/20.
//

import SwiftUI

extension DialogContent {
    struct NeedUpdateDialog: View {
        let updateTitle: String
        let updateMessage: String
        let action: () -> Void
        
        var body: some View {
            VStack(spacing: 32) {
                VStack(spacing: 8) {
                    Text(updateTitle)
                        .bold()
                        .foregroundColor(.black)
                    
                    Text(updateMessage)
                        .foregroundColor(.black)
                }
                
                if #available(iOS 15.0, *) {
                    Button("업데이트", role: .destructive) {
                        action()
                    }
                } else {
                    Button("업데이트") {
                        action()
                    }
                }
            }
            .padding(16)
            .frame(minWidth: 270, minHeight: 144)
        }
    }
    
    struct SuggestUpdateDialog: View {
        let updateTitle: String
        let updateMessage: String
        let dismissAction: () -> Void
        let updateAction: () -> Void
        
        var body: some View {
            VStack(spacing: 32) {
                VStack(spacing: 8) {
                    Text(updateTitle)
                        .bold()
                        .foregroundColor(.black)
                    
                    Text(updateMessage)
                        .foregroundColor(.black)
                }
                
                HStack(spacing: 0) {
                    if #available(iOS 15.0, *) {
                        Spacer()
                        
                        Button("다음에", role: .cancel) {
                            dismissAction()
                            
                            DialogPresentation.shared.hide()
                        }
                        
                        Spacer()
                        
                        Button("업데이트", role: .destructive) {
                            updateAction()
                        }
                        
                        Spacer()
                    } else {
                        Spacer()
                        
                        Button("다음에") {
                            dismissAction()
                            
                            DialogPresentation.shared.hide()
                        }
                        
                        Spacer()
                        
                        Button("업데이트") {
                            updateAction()
                        }
                        
                        Spacer()
                    }
                }
            }
            .padding(16)
            .frame(minWidth: 270, minHeight: 144)
        }
    }
}

struct DialogContent_Previews: PreviewProvider {
    static var previews: some View {
        DialogContent.NeedUpdateDialog(updateTitle: "업데이트하기", updateMessage: "필수 업데이트가 있습니다!", action: {})
    }
}

//
//  DialogPresentation.swift
//  HotKeyword
//
//  Created by 이창수 on 2022/05/20.
//

import SwiftUI

struct DialogSettings {
    var width: CGFloat?
    var height: CGFloat?
    var backgroundColor: Color = .white
    var canTouchOutside: Bool = false
}

final class DialogPresentation: ObservableObject {
    static let shared = DialogPresentation()
    
    @Published var dialogContent: DialogContent?
    
    var settings = DialogSettings()
    
    private init() {}
    
    func show(_ content: DialogContent,
              width: CGFloat? = nil,
              height: CGFloat? = nil,
              backgroundColor: Color = .white,
              canTouchOutside: Bool = false) {
        settings = DialogSettings(width: width, height: height, backgroundColor: backgroundColor, canTouchOutside: canTouchOutside)
        dialogContent = content
    }
    
    func hide() {
        settings = DialogSettings()
        dialogContent = nil
    }
}

struct CustomDialog: ViewModifier {
    @ObservedObject var manager: DialogPresentation
    
    init(presentationManager: DialogPresentation) {
        self.manager = presentationManager
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if let dialogContent = manager.dialogContent {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        UIApplication.shared.windows.forEach { $0.endEditing(false) } // 키보드 닫기
                        
                        if manager.settings.canTouchOutside {
                            manager.hide()
                        }
                    }
                
                dialogContent
                    .frame(width: manager.settings.width, height: manager.settings.height)
                    .background(
                        manager.settings.backgroundColor
                            .cornerRadius(8)
                    )
                    .padding(40)
            }
        }
    }
}

extension View {
    func customDialog(
        presentationManager: DialogPresentation
    ) -> some View {
        self.modifier(CustomDialog(presentationManager: presentationManager))
    }
}

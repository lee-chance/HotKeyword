//
//  DialogContent.swift
//  HotKeyword
//
//  Created by 이창수 on 2022/05/20.
//

import SwiftUI

enum DialogContent {
    case requiredUpdateDialog(detail: AppInitialize.VersionCheckDetail, action: () -> Void)
    case optionalUpdateDialog(detail: AppInitialize.VersionCheckDetail, dismissAction: () -> Void, updateAction: () -> Void)
}

extension DialogContent: View {
    var body: some View {
        switch self {
        case let .requiredUpdateDialog(detail, action):
            NeedUpdateDialog(updateTitle: detail.title, updateMessage: detail.message, action: action)
        case let .optionalUpdateDialog(detail, dismissAction, updateAction):
            SuggestUpdateDialog(updateTitle: detail.title, updateMessage: detail.message, dismissAction: dismissAction, updateAction: updateAction)
        }
    }
}

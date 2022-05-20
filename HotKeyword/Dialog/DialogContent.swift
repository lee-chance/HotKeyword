//
//  DialogContent.swift
//  HotKeyword
//
//  Created by 이창수 on 2022/05/20.
//

import SwiftUI

enum DialogContent {
    case needUpdateDialog(action: () -> Void)
    case suggestUpdateDialog(dismissAction: () -> Void, updateAction: () -> Void)
}

extension DialogContent: View {
    var body: some View {
        switch self {
        case .needUpdateDialog(let action): NeedUpdateDialog(action: action)
        case .suggestUpdateDialog(let dismissAction, let updateAction): SuggestUpdateDialog(dismissAction: dismissAction, updateAction: updateAction)
        }
    }
}

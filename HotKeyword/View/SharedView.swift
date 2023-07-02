//
//  SharedView.swift
//  HotKeyword
//
//  Created by Changsu Lee on 2022/05/12.
//

import SwiftUI

struct KeywordRow: View {
    let keyword: HotKeyword
    
    var body: some View {
        HStack {
            Rectangle()
                .frame(width: 32, height: 32)
                .foregroundColor(.gray.opacity(0.3))
                .cornerRadius(8)
                .overlay(
                    Text("\(keyword.rank)")
                )
            
            Text(keyword.text)
            
            Spacer()
        }
    }
}

struct UpdatedDateText: View {
    let updatedDate: Date
    
    var body: some View {
        #if DEBUG
        Text("\(updatedDate.toString(format: "HH시 mm분 ss초"))")
            .font(.caption)
            .foregroundColor(.gray)
            .frame(maxWidth: .infinity, alignment: .trailing)
        #else
        Text("\(updatedDate.toString(format: "HH시 mm분"))")
            .font(.caption)
            .foregroundColor(.gray)
            .frame(maxWidth: .infinity, alignment: .trailing)
        #endif
    }
}

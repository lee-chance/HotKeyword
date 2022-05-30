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
            Text("\(keyword.rank)")
                .foregroundColor(.text)
                .frame(width: 32, height: 32)
                .background(
                    Rectangle()
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(8)
                )
            
            Text(keyword.text)
                .foregroundColor(.text)
        }
        .foregroundColor(.clear)
    }
}

struct UpdatedDateText: View {
    let updatedDate: Date
    
    var body: some View {
        Text("\(updatedDate.toString(format: "HH시 mm분 ss초"))")
            .font(Font.caption)
            .foregroundColor(.gray)
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

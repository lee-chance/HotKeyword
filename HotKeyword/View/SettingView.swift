//
//  SettingView.swift
//  HotKeyword
//
//  Created by 이창수 on 2022/05/20.
//

import SwiftUI

struct SettingView: View {
    @AppStorage(AppStorageKey.searchEngine.key) var searchEngine: SearchEngine = .naver
    @AppStorage(AppStorageKey.allowsNotification.key) var allowsNotification: Bool = false {
        didSet {
            if allowsNotification {
                FCMManager.subscribe(topic: .hotKeyword(clock: 9)) { _ in
                    allowsNotification = false
                }
            } else {
                FCMManager.unsubscribe(topic: .hotKeyword(clock: 9)) { _ in
                    allowsNotification = true
                }
            }
        }
    }
    
    var body: some View {
        List {
            if #available(iOS 15.0, *) {
                Picker("\(searchEngine.kor)에서 검색하기", selection: $searchEngine) {
                    ForEach(SearchEngine.allCases) { engine in
                        Text(engine.kor)
                            .tag(engine)
                    }
                }
                .pickerStyle(.inline)
            } else {
                Section {
                    HStack {
                        Text(searchEngine.kor)
                        
                        Spacer()
                        
                        Picker("변경하기", selection: $searchEngine) {
                            ForEach(SearchEngine.allCases) { engine in
                                Text(engine.kor)
                                    .tag(engine)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                } header: {
                    Text("어디서 검색할까요?")
                }
            }
            
            Section {
                HStack {
                    VStack(alignment: .leading) {
                        Text("푸시 알림")
                        
                        Text("매일 아침 09:00에 알림 받기")
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .lineLimit(1)
                            .minimumScaleFactor(0.1)
                    }
                    
                    Spacer()
                    
                    Toggle("", isOn: $allowsNotification)
                }
            } header: {
                Text("알림")
            }
            
            Section {
                HStack {
                    Text("현재 앱 버전")
                    
                    Spacer()
                    
                    Text(HotKeywordInfo.appVersion ?? "1.0")
                }
            } header: {
                Text("기타")
            }
        }
        .padding(.top, 1)
        .background(Color(uiColor: .systemGray6))
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}

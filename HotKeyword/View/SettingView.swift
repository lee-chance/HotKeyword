//
//  SettingView.swift
//  HotKeyword
//
//  Created by 이창수 on 2022/05/20.
//

import SwiftUI

struct SettingView: View {
    @State private var selectedSearchEngine: SearchEngine
    @ObservedObject var settings = AppSettings.shared
    
    init() {
        self.selectedSearchEngine = AppSettings.shared.searchEngine
    }
    
    var body: some View {
        List {
            if #available(iOS 15.0, *) {
                Picker("\(selectedSearchEngine.kor)에서 검색하기", selection: $selectedSearchEngine) {
                    ForEach(SearchEngine.allCases) { engine in
                        Text(engine.kor)
                            .tag(engine)
                    }
                }
                .pickerStyle(.inline)
                .onChange(of: selectedSearchEngine) { newValue in
                    AppSettings.shared.setSearchEngine(newValue)
                }
            } else {
                Section {
                    HStack {
                        Text(selectedSearchEngine.kor)
                        
                        Spacer()
                        
                        Picker("변경하기", selection: $selectedSearchEngine) {
                            ForEach(SearchEngine.allCases) { engine in
                                Text(engine.kor)
                                    .tag(engine)
                            }
                        }
                        .pickerStyle(.menu)
                        .onChange(of: selectedSearchEngine) { newValue in
                            AppSettings.shared.setSearchEngine(newValue)
                        }
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
                    
                    Toggle("", isOn: $settings.allowsNotification)
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
        .navigationTitle("설정")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}

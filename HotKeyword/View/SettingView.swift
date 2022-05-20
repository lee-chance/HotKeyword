//
//  SettingView.swift
//  HotKeyword
//
//  Created by 이창수 on 2022/05/20.
//

import SwiftUI

struct SettingView: View {
    @State private var selectedSearchEngine: SearchEngine
    
    init() {
        self.selectedSearchEngine = AppSettings.shared.searchEngine
    }
    
    var body: some View {
        List {
            if #available(iOS 15.0, *) {
                Picker("검색엔진", selection: $selectedSearchEngine) {
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
                    Text("검색엔진")
                }
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

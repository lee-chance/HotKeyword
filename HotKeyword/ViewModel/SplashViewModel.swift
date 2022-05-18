//
//  SplashViewModel.swift
//  HotKeyword
//
//  Created by 이창수 on 2022/05/17.
//

import SwiftUI
import Combine

final class SplashViewModel: ObservableObject {
    private let provider = ServiceProvider<FirebaseService>()
    
    func doStep() {
        if #available(iOS 15.0, *) {
            Task {
                print("== async/await response ==")
                do {
                    let response = try await provider.get(service: .initialize, decodeType: AppInitialize.self)
                    print("response: \(response)")
                } catch {
                    print("error: \(error)")
                }
            }
        } else {
            provider.get(service: .initialize, decodeType: AppInitialize.self) { result in
                print("== callback response ==")
                switch result {
                case .success(let response):
                    print("response: \(response)")
                case .failure(let error):
                    print("error: \(error)")
                }
            }
        }
    }
}


struct AppInitialize: Codable {
    var pointPerClick: CGFloat
}

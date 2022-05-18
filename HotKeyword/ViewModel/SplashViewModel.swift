//
//  SplashViewModel.swift
//  HotKeyword
//
//  Created by 이창수 on 2022/05/17.
//

import SwiftUI
import Combine

final class SplashViewModel: ObservableObject {
    private var tasks = [() -> Void]()
    private let provider = ServiceProvider<FirebaseService>()
    
    @Published var isLogoAnimationOn = false
    @Published var showSplashView = true
    
    init() {
        initiaize()
    }
    
    private func initiaize() {
        Async.serial(tasks: [
            { [weak self] done in
                self?.provider.get(service: .initialize, decodeType: AppInitialize.self) { result in
                    switch result {
                    case .success(let response):
                        AppSettings.shared.setPointPerClick(point: response.pointPerClick)
                        done(nil)
                    case .failure(let error):
                        print("error: \(error)")
                        done(error)
                    }
                }
            },
            
            { [weak self] done in
                withAnimation(.spring(response: 0.7, dampingFraction: 0.6)) {
                    self?.isLogoAnimationOn.toggle()
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.35) {
                    withAnimation {
                        self?.showSplashView.toggle()
                        done(nil)
                    }
                }
            }
        ], result: { error in
            print("error: \(error)")
        })
    }
}

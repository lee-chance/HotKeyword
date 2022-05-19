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
    private var cancellables = Set<AnyCancellable>()
    
    @Published var isLogoAnimationOn = false
    @Published var showSplashView = true
    
    init() {
        initiaize()
    }
    
    func invalidate() {
        cancellables.forEach { $0.cancel() }
        cancellables = []
    }
    
    private func initiaize() {
        Async.serial(tasks: [
            { [weak self] in self?.appInitialize(completion: $0) }
        ], result: { [weak self] result in
            switch result {
            case .success:
                self?.animate()
            case .failure(let error):
                print("error: \(error)")
            }
        })
    }
    
    private func appInitialize(completion: @escaping (Async.TaskResult) -> Void) {
        provider.get(service: .initialize, decodeType: AppInitialize.self)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    completion(.success)
                case .failure(let error):
                    completion(.failure(error))
                }
            }, receiveValue: { response in
                AppSettings.shared.setPointPerClick(point: response.pointPerClick)
            })
            .store(in: &cancellables)
    }
    
    private func animate() {
        withAnimation(.spring(response: 0.7, dampingFraction: 0.6)) {
            isLogoAnimationOn.toggle()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.35) { [weak self] in
            withAnimation {
                self?.showSplashView.toggle()
            }
        }
    }
}

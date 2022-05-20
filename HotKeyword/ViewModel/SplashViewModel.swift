//
//  SplashViewModel.swift
//  HotKeyword
//
//  Created by 이창수 on 2022/05/17.
//

import SwiftUI

enum SplashError: Error {
    case needUpdate
    case unknown
}

final class SplashViewModel: ObservableObject {
    private var tasks = [() -> Void]()
    private let provider = ServiceProvider<FirebaseService>()
    
    @Published var isLogoAnimationOn = false
    @Published var showSplashView = true
    
    init() {
        initialize()
    }
    
    private func initialize() {
        Async.serial(tasks: [
            { [weak self] done in
                self?.provider.get(service: .versionCheck, decodeType: AppInitialize.VersionCheck.self) { result in
                    switch result {
                    case .success(let response):
                        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
                            done(.failure(SplashError.unknown))
                            return
                        }
                        
                        let currentVersion = Version(string: version)
                        let requiredVersion = Version(string: response.requiredVersion)
                        let optionalVersion = Version(string: response.optionalVersion)
                        
                        if currentVersion < requiredVersion {
                            DispatchQueue.main.async {
                                DialogPresentation.shared.show(.needUpdateDialog(action: { done(.failure(SplashError.needUpdate)) }))
                            }
                        } else if currentVersion < optionalVersion {
                            let dialog = DialogContent.suggestUpdateDialog(dismissAction: { done(.success) }, updateAction: { done(.failure(SplashError.needUpdate)) })
                            DispatchQueue.main.async {
                                DialogPresentation.shared.show(dialog)
                            }
                        } else {
                            done(.success)
                        }
                    case .failure(let error):
                        done(.failure(error))
                    }
                }
            },
            
            { [weak self] done in
                self?.provider.get(service: .initialize, decodeType: AppInitialize.Initialize.self) { result in
                    switch result {
                    case .success(let response):
                        AppSettings.shared.setPointPerClick(point: response.pointPerClick)
                        done(.success)
                    case .failure(let error):
                        done(.failure(error))
                    }
                }
            }
        ], result: { [weak self] result in
            switch result {
            case .success:
                self?.animate()
            case .failure(let error):
                switch error {
                case SplashError.needUpdate: print("앱스토어로 이동~") // TODO: 앱스토어로 이동~
                default: print("error: \(error)")
                }
            }
        })
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


// use combine

//import Combine
//
//final class SplashViewModel: ObservableObject {
//    private var tasks = [() -> Void]()
//    private let provider = ServiceProvider<FirebaseService>()
//    private var cancellables = Set<AnyCancellable>()
//
//    @Published var isLogoAnimationOn = false
//    @Published var showSplashView = true
//
//    init() {
//        initiaize()
//    }
//
//    func invalidate() {
//        cancellables.forEach { $0.cancel() }
//        cancellables = []
//    }
//
//    private func initiaize() {
//        Async.serial(tasks: [
//            { [weak self] in self?.appInitialize(completion: $0) }
//        ], result: { [weak self] result in
//            switch result {
//            case .success:
//                self?.animate()
//            case .failure(let error):
//                print("error: \(error)")
//            }
//        })
//    }
//
//    private func appInitialize(completion: @escaping (Async.TaskResult) -> Void) {
//        provider.get(service: .initialize, decodeType: AppInitialize.self)
//            .sink(receiveCompletion: { result in
//                switch result {
//                case .finished:
//                    completion(.success)
//                case .failure(let error):
//                    completion(.failure(error))
//                }
//            }, receiveValue: { response in
//                AppSettings.shared.setPointPerClick(point: response.pointPerClick)
//            })
//            .store(in: &cancellables)
//    }
//
//    private func animate() {
//        withAnimation(.spring(response: 0.7, dampingFraction: 0.6)) {
//            isLogoAnimationOn.toggle()
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.35) { [weak self] in
//            withAnimation {
//                self?.showSplashView.toggle()
//            }
//        }
//    }
//}

//
//  LottieView.swift
//  HotKeyword
//
//  Created by 이창수 on 2022/07/18.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    private let animationView: AnimationView
    private let completion: LottieCompletionBlock?
    
    init(filename: String, completion: ((Bool) -> Void)? = nil) {
        let animationView = AnimationView()
        animationView.animation = Animation.named(filename)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.backgroundBehavior = .pauseAndRestore
        self.animationView = animationView
        self.completion = completion
    }
    
    init(animationView: AnimationView, completion: ((Bool) -> Void)? = nil) {
        self.animationView = animationView
        self.completion = completion
    }
    
    class Coordinator: NSObject {
        var parent: LottieView
        
        init(_ animationView: LottieView) {
            self.parent = animationView
            super.init()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> some UIView {
        let view = UIView()
        
        animationView.play(completion: completion)
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: UIViewRepresentableContext<LottieView>) {}
}

struct LottieView_Previews: PreviewProvider {
    static var previews: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 3)) {
            ForEach(["clear-sky", "few-clouds", "scattered-clouds", "broken-clouds", "mist", "shower-rains", "rain", "snow", "thunderstorm"], id: \.self) { name in
                LottieView(filename: "weather-day-\(name).json")
                    .frame(width: 100, height: 100)
            }
            
            ForEach(["clear-sky", "few-clouds", "scattered-clouds", "broken-clouds", "mist", "shower-rains", "rain", "snow", "thunderstorm"], id: \.self.hashValue) { name in
                LottieView(filename: "weather-night-\(name).json")
                    .frame(width: 100, height: 100)
            }
        }
    }
}

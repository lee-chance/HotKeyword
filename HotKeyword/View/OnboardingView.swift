//
//  OnboardingView.swift
//  HotKeyword
//
//  Created by Changsu Lee on 2023/07/02.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectionIndex: Step = .keyword
    @State private var animateGradient = true
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                TabView(selection: $selectionIndex) {
                    ForEach(Step.allCases) { step in
                        VStack {
                            LottieView(filename: step.lottieFilename)
                                .frame(maxHeight: geometry.size.height * 2 / 5)
                            
                            Text(step.title)
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(.black)
                            
                            Capsule()
                                .frame(width: geometry.size.width / 2, height: 3)
                                .foregroundColor(.white)
                                .padding(.bottom)
                            
                            Text(step.description)
                                .multilineTextAlignment(.center)
                                .lineSpacing(8)
                                .foregroundColor(.black)
                        }
                    }
                    .padding()
                    .padding(.bottom, geometry.size.height / 8)
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
            }
            
            HStack {
                Spacer()
                
                Button(selectionIndex == Step.allCases.last ? "시작하기" : "건너뛰기") { dismiss() }
            }
            .padding()
            .padding(.horizontal)
        }
        .background(
            LinearGradient(
                colors: [.mainOrange, .mainYellow],
                startPoint: animateGradient ? .topLeading : .topTrailing,
                endPoint: animateGradient ? .bottomTrailing : .bottomLeading
            )
            .ignoresSafeArea()
            .animation(.linear(duration: 2).repeatForever(autoreverses: true), value: animateGradient)
            .onAppear {
                animateGradient.toggle()
            }
        )
    }
}

private extension OnboardingView {
    enum Step: Identifiable, CaseIterable {
        case keyword, news, weather
        
        var id: Self { self }
        
        var lottieFilename: String {
            switch self {
            case .keyword:
                return "keyword-onboarding"
            case .news:
                return "news-onboarding"
            case .weather:
                return "weather-onboarding"
            }
        }
        
        var title: String {
            switch self {
            case .keyword:
                return "실시간 검색어"
            case .news:
                return "실시간 뉴스"
            case .weather:
                return "실시간 날씨"
            }
        }
        
        var description: String {
            switch self {
            case .keyword:
                return "실시간으로 업데이트 되는 검색어들은 빠르게 변하는 트렌드를 놓치지 않도록 도와줍니다."
            case .news:
                return "뉴스탭은 심플한 화면으로 한국의 뉴스를 빠르고 편리하게 접할 수 있습니다."
            case .weather:
                return "현재 위치의 실시간, 48시간, 이번주 날씨 정보를 신속하게 확인할 수 있습니다."
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}

//
//  GoogleADBannerView.swift
//  HotKeyword
//
//  Created by Changsu Lee on 2022/05/22.
//

import SwiftUI
import GoogleMobileAds

struct GoogleADBannerView: UIViewRepresentable {
    var unitID: String
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    func makeUIView(context: Context) -> GADBannerView {
        let bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.adUnitID = unitID
        bannerView.rootViewController = UIApplication.shared.getRootViewController()
        bannerView.delegate = context.coordinator
        
        bannerView.load(GADRequest())
        
        return bannerView
    }
    
    func updateUIView(_ uiView: GADBannerView, context: Context) {
        
    }
    
    class Coordinator: NSObject, GADBannerViewDelegate {
//        func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
//            print("bannerViewDidReceiveAd")
//        }
//
//        func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
//            print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
//        }
//
//        func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
//            print("bannerViewDidRecordImpression")
//        }
//
//        func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
//            print("bannerViewWillPresentScreen")
//        }
//
//        func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
//            print("bannerViewWillDIsmissScreen")
//        }
//
//        func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
//            print("bannerViewDidDismissScreen")
//        }
    }
}

extension UIApplication {
    func getRootViewController() -> UIViewController {
        guard let screen = self.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        
        return root
    }
}

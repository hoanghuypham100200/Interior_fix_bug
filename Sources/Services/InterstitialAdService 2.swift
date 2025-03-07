import Foundation
import GoogleMobileAds
import Firebase
import RxSwift
import ProgressHUD

final class InterstitialAdService: NSObject {
    
    // MARK: Public
    static let shared: InterstitialAdService = .init()
    
    // MARK: Pivate properties
    private var interstitialAd: GADInterstitialAd?
}

extension InterstitialAdService {
    func preloadAdIfNeeded() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: AdMob.interstitialAdId,
                               request: request,
                               completionHandler: { [self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            interstitialAd = ad
            interstitialAd?.fullScreenContentDelegate = self
        })
    }
    
    func loadInterstitialAd(on controller: UIViewController,
                        completion: @escaping (Bool) -> ()) {
        guard interstitialAd == nil else {
            presentAd(on: controller) {
                completion(true)
            }
            return
        }
        
        loadAd { [weak self] hasAd in
            guard let wSelf = self, hasAd else {
                completion(false)
                return
            }
            
            wSelf.presentAd(on: controller) {
                completion(true)
            }
        }
    }
    
    func displayInterstitialAd(viewController: UIViewController) {
        let userDefault = UserDefaultService.shared
        let viewModel: HomeViewModel = .init()
        
        if (!viewModel.isPurchase && !userDefault.isPurchase) {
            userDefault.interstitialScreenSwitch += 1
            if (userDefault.interstitialScreenSwitch < viewModel.interstitialScreenSwitch.interstitialScreenSwitch) {
            } else {
                self.loadInterstitialAd(on: viewController) { didEarn in
                    guard didEarn else {
                        return
                    }
                }
                userDefault.interstitialScreenSwitch = 1
            }
        }
    }
}

extension InterstitialAdService: GADFullScreenContentDelegate {
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
    }
    
    /// Tells the delegate that the ad will present full screen content.
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad will present full screen content.")
    }
    
    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
    }
}


private extension InterstitialAdService {
    func loadAd(completion: @escaping (Bool) -> ()) {
        guard interstitialAd == nil else { return }
        
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: AdMob.interstitialAdId,
                               request: request,
                               completionHandler: { [weak self] ad, error in
            guard let wSelf = self else { return }
            
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                completion(false)
                return
            }
            wSelf.interstitialAd = ad
            wSelf.interstitialAd?.fullScreenContentDelegate = wSelf
            print("InterstitialAd ad loaded.")
            completion(true)
        })
    }
    
    func presentAd(on controller: UIViewController, completion: @escaping () -> Void) {
        interstitialAd?.present(fromRootViewController: controller)
    }
}

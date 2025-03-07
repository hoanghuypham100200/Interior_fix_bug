import Foundation
import GoogleMobileAds
import Firebase
import RxSwift

final class InterstitialAdService: NSObject {
    
    // MARK: Public
    static let shared: InterstitialAdService = .init()
    
    // MARK: Pivate properties
    private var interstitialAd: GADInterstitialAd?
    
    let disposeBag = DisposeBag()
    let userDefault = UserDefaultService.shared
}

extension InterstitialAdService {
    
    func loadADByID(adID: String) -> Observable<Bool> {
        Observable<Bool>.create { [weak self] observer in
            let disposable = Disposables.create()
        
            guard let owner = self else {
                observer.onCompleted()
                return disposable
            }
            
            let request = GADRequest()
            GADInterstitialAd.load(withAdUnitID: adID,
                                   request: request,
                                   completionHandler: { ad, error in
                if let error = error {
                    print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                    observer.onNext(false)
                    observer.onCompleted()
                } else {
                    owner.interstitialAd = ad
                    owner.interstitialAd?.fullScreenContentDelegate = owner
                    print("InterstitialAd ad loaded.")
                    observer.onNext(true)
                    observer.onCompleted()
                }
            })
            return disposable
        }
    }
    
    func preloadAd() -> Observable<Bool> {
        Observable<Bool>.create { [weak self] observer in
            let disposable = Disposables.create()
            let userDefault = UserDefaultService.shared
            let interstitalEnable = AdsManager.shared.adsConfigValue.interstital.enable
            
            // Check retain cycle, premium user, enable
            guard let owner = self, !userDefault.isPurchase, interstitalEnable else {
                observer.onCompleted()
                return disposable
            }
            
            if owner.interstitialAd == nil {
                // Load HF
                owner.loadADByID(adID: AdMob.interstitialAdHighId)
                    .subscribe(on: scheduler.main)
                    .withUnretained(owner)
                    .flatMapLatest { owner, didEarnHF in
                        if didEarnHF {
                            return Observable.just(true)
                        } else {
                            // Load MF
                            return owner.loadADByID(adID: AdMob.interstitialAdMediumId)
                        }
                    }
                    .observe(on: scheduler.main)
                    .subscribe(onNext: { value in
                        observer.onNext(value)
                        observer.onCompleted()
                    })
                    .disposed(by: owner.disposeBag)
            } else {
                observer.onNext(true)
                observer.onCompleted()
            }
            
            return disposable
        }
    }
    
    func showAd(on controller: UIViewController) -> Observable<Bool> {
        Observable<Bool>.create { [weak self] observer in
            let disposable = Disposables.create()
            let userDefault = UserDefaultService.shared
            let interstitalConfig = AdsManager.shared.adsConfigValue.interstital
            
            // RC time
            let timeRC = interstitalConfig.time
            
            // Current time
            let currentTime = Int((Date().timeIntervalSince1970).rounded())
            
            // Last time
            let lastTime = userDefault.adsConfig.interstitialLastTime
            
            print("===> Current Time 1: \(currentTime) - Last Time: \(lastTime)")
            
            // Check retain cycle, premium user, enable, last time
            guard let owner = self, !userDefault.isPurchase, interstitalConfig.enable, (currentTime - lastTime) > timeRC else {
                observer.onCompleted()
                return disposable
            }
            
            print("===> Current Time 2: \(currentTime) - Last Time: \(lastTime)")
            
            if owner.interstitialAd == nil {
                // Chưa có ad - load ad
                owner.preloadAd()
                    .withUnretained(owner)
                    .observe(on: scheduler.main)
                    .subscribe(onNext: { owner, hasAd in
                        if hasAd {
                            // Load được ad - show ad
                            owner.presentAd(on: controller)
                            observer.onNext(true)
                            observer.onCompleted()
                        } else {
                            // Không load được ad
                            observer.onNext(false)
                            observer.onCompleted()
                        }
                    })
                    .disposed(by: owner.disposeBag)
                
            } else {
                owner.presentAd(on: controller)
                observer.onNext(true)
                observer.onCompleted()
            }
            
            return disposable
        }
    }
}

extension InterstitialAdService: GADFullScreenContentDelegate {
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Interstitial Ad did fail to present full screen content.")
        interstitialAd = nil
        preloadAd()
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: { owner, _ in })
            .disposed(by: disposeBag)
    }
    
    /// Tells the delegate that the ad will present full screen content.
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Interstitial Ad will present full screen content.")
    }
    
    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Interstitial Ad did dismiss full screen content.")
        interstitialAd = nil
        preloadAd()
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: { owner, _ in })
            .disposed(by: disposeBag)
    }
}

private extension InterstitialAdService {
    
    func presentAd(on controller: UIViewController) {
        interstitialAd?.present(fromRootViewController: controller)
        // Set lastime show ad
        let currentTime = Int((Date().timeIntervalSince1970).rounded())
        userDefault.adsConfig.interstitialLastTime = currentTime
    }
}

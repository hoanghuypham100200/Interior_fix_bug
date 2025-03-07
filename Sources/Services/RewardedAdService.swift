import Foundation
import GoogleMobileAds
import Firebase
import RxSwift

protocol RewardedAdServiceDelegate: NSObjectProtocol {
    func rwAdDidDismiss()
}

final class RewardedAdService: NSObject {
    
    // MARK: Public
    static let shared: RewardedAdService = .init()
    
    // MARK: Pivate properties
    private var rewardedAd: GADRewardedAd?
    weak var delegate: RewardedAdServiceDelegate?
    let disposeBag = DisposeBag()
}

extension RewardedAdService {
    
    func loadADByID(adID: String) -> Observable<Bool> {
        Observable<Bool>.create { [weak self] observer in
            let disposable = Disposables.create()
            
            guard let owner = self else {
                observer.onCompleted()
                return disposable
            }
            
            let request = GADRequest()
            GADRewardedAd.load(withAdUnitID: adID,
                               request: request,
                               completionHandler: { ad, error in
                
                if let error = error {
                    print("Failed to load rewarded ad with error: \(error.localizedDescription)")
                    observer.onNext(false)
                    observer.onCompleted()
                } else {
                    owner.rewardedAd = ad
                    owner.rewardedAd?.fullScreenContentDelegate = owner
                    print("Rewarded ad loaded.")
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
            let rewardedEnable = AdsManager.shared.adsConfigValue.rewarded.enable
            
            // Check retain cycle, premium user, enable
            guard let owner = self, !userDefault.isPurchase, rewardedEnable else {
                observer.onCompleted()
                return disposable
            }
            
            if owner.rewardedAd == nil {
                // Load HF
                owner.loadADByID(adID: AdMob.rewardedAdHighId)
                    .subscribe(on: scheduler.main)
                    .withUnretained(owner)
                    .flatMapLatest { owner, didEarnHF in
                        if didEarnHF {
                            return Observable.just(true)
                        } else {
                            // Load MF
                            return owner.loadADByID(adID: AdMob.rewardedAdMediumId)
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
            let rewardedConfig = AdsManager.shared.adsConfigValue.rewarded
            // Check retain cycle, premium user, enable
            guard let owner = self, !userDefault.isPurchase, rewardedConfig.enable else {
                observer.onCompleted()
                return disposable
            }
            // Check đã có preload ad chưa
            if owner.rewardedAd == nil {
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

extension RewardedAdService: GADFullScreenContentDelegate {

    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Rewarded Ad did fail to present full screen content.")
        rewardedAd = nil
        preloadAd()
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: { owner, _ in })
            .disposed(by: disposeBag)
    }
    
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Rewarded Ad will present full screen content.")
    }

    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Rewarded Ad did dismiss full screen content.")
        delegate?.rwAdDidDismiss()
        rewardedAd = nil
        preloadAd()
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: { owner, _ in })
            .disposed(by: disposeBag)
    }
}

private extension RewardedAdService {
    
    func presentAd(on controller: UIViewController) {
        rewardedAd?.present(fromRootViewController: controller) {}
    }
}

import GoogleMobileAds
import RxSwift
import RxCocoa

protocol AppOpenAdServiceDelegate: AnyObject {
    func appOpenAdServiceAdDidComplete(_ appOpenAdService: AppOpenAdService)
}

class AppOpenAdService: NSObject {
    let timeoutInterval: TimeInterval = 4 * 3_600
    var appOpenAd: GADAppOpenAd?
    weak var appOpenAdServiceDelegate: AppOpenAdServiceDelegate?
    var isLoadingAd = false
    var isShowingAd = false
    var loadTime: Date?
    
    private let disposeBag = DisposeBag()
    
    static let shared = AppOpenAdService()
    
    private func wasLoadTimeLessThanNHoursAgo(timeoutInterval: TimeInterval) -> Bool {
        if let loadTime = loadTime {
            return Date().timeIntervalSince(loadTime) < timeoutInterval
        }
        return false
    }
    
    private func isAdAvailable() -> Bool {
        return appOpenAd != nil && wasLoadTimeLessThanNHoursAgo(timeoutInterval: timeoutInterval)
    }
    
    private func appOpenAdManagerAdDidComplete() {
        appOpenAdServiceDelegate?.appOpenAdServiceAdDidComplete(self)
    }
    
    func preloadAd() -> Single<GADAppOpenAd> {
        guard !isLoadingAd, !isAdAvailable() else {
            return Single.error(NSError(domain: "OpenAdService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Ad is already loading or available"]))
        }
        
        isLoadingAd = true
        print("Start preloading app open ad.")
        
        return GADAppOpenAd.rx.load(withAdUnitID: AdMob.appOpenAdId, request: GADRequest())
            .do(onSuccess: { [weak self] appOpenAd in
                guard let self = self else { return }
                self.appOpenAd = appOpenAd
                self.appOpenAd?.fullScreenContentDelegate = self
                self.loadTime = Date()
                self.isLoadingAd = false
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.appOpenAd = nil
                self.loadTime = nil
                self.isLoadingAd = false
                print("App open ad failed to preload with error: \(error.localizedDescription)")
            })
    }
    
    func showAd() -> Observable<Bool> {
        Observable<Bool>.create { [weak self] observer in
            let disposable = Disposables.create()
            let userDefault = UserDefaultService.shared
            
            print("Count show DS: \(userDefault.adsConfig.countShowDS.count)")
            
            // Check retain cycle, purchase, If the app open ad is already showing, do not show the ad again.
            guard let owner = self, !userDefault.isPurchase, !owner.isShowingAd, userDefault.adsConfig.countShowDS.count == 0 else {
                observer.onNext(false)
                observer.onCompleted()
                return disposable
            }
            
            guard owner.isAdAvailable() else {
                print("App open ad is not ready yet.")
                owner.appOpenAdManagerAdDidComplete()
                
                // Preload
                owner.preloadAd()
                    .subscribe(onSuccess: { [weak self] appOpenAd in
                        guard let owner = self else { return }
                        print("Ad preloaded successfully.")
                        // You can now use `appOpenAd` if needed
                        owner.isShowingAd = true
                        appOpenAd.present(fromRootViewController: nil)
                        observer.onNext(true)
                        observer.onCompleted()
                        
                    }, onFailure: { error in
                        print("Failed to preload ad: \(error.localizedDescription)")
                        observer.onNext(false)
                        observer.onCompleted()
                    })
                    .disposed(by: owner.disposeBag)
                
                return disposable
            }
            
            if let ad = owner.appOpenAd {
                print("App open ad will be displayed.")
                owner.isShowingAd = true
                ad.present(fromRootViewController: nil)
                observer.onNext(true)
                observer.onCompleted()
            } else {
                observer.onNext(false)
                observer.onCompleted()
            }
            
            return disposable
        }
    }
    
    func loadAd() {
        preloadAd()
            .subscribe(onSuccess: { [weak self] appOpenAd in
                guard let _ = self else { return }
                print("Preload App Open: successfully.")
            }, onFailure: { error in
                print("Preload App Open: Failed to preload ad: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
}

extension AppOpenAdService: GADFullScreenContentDelegate {
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("App open ad will be presented.")
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        appOpenAd = nil
        isShowingAd = false
        print("App open ad was dismissed.")
        appOpenAdManagerAdDidComplete()
        loadAd()
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        appOpenAd = nil
        isShowingAd = false
        print("App open ad failed to present with error: \(error.localizedDescription)")
        appOpenAdManagerAdDidComplete()
        loadAd()
    }
}

extension Reactive where Base: GADAppOpenAd {
    static func load(withAdUnitID adUnitID: String, request: GADRequest) -> Single<GADAppOpenAd> {
        return Single.create { single in
            Task {
                do {
                    let appOpenAd = try await GADAppOpenAd.load(withAdUnitID: adUnitID, request: request)
                    single(.success(appOpenAd))
                } catch {
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
}

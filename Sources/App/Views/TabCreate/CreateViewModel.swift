import Foundation
import NVActivityIndicatorView
import RxSwift
import UIKit

class CreateViewModel: BaseViewModel {
    
    static let shared = CreateViewModel.init()
    private let userDefault = UserDefaultService.shared
    
    let defaultError = NSError(domain: "", code: 123, userInfo: [NSLocalizedDescriptionKey: "Something went wrong. Please try again!"])
    
    private var modelManager: ModelManager {
        ModelManagerImpl.shared
    }
    
    private var remoteConfigManager: RemoteConfigManager {
        RemoteConfigManagerImpl.shared
    }
    
    var ratioConfigOsb: Observable<[RatioConfigModel]> {
        remoteConfigManager.ratioConfigOsb
    }
    
    var ratioConfigValue: [RatioConfigModel] {
        remoteConfigManager.ratioConfigValue
    }
    
    var styleConfigOsb: Observable<[StyleConfigModel]> {
        remoteConfigManager.styleConfigOsb
    }
    
    var styleConfigValue: [StyleConfigModel] {
        remoteConfigManager.styleConfigValue
    }
    
    var roomConfigOsb: Observable<[RoomTypeModel]> {
        remoteConfigManager.roomConfigOsb
    }
    
    var roomConfigValue: [RoomTypeModel] {
        remoteConfigManager.roomConfigValue
    }
    
    var limitConfigOsb: Observable<LimitConfigModel> {
        remoteConfigManager.limitConfigOsb
    }
    
    var limitConfigValue: LimitConfigModel {
        remoteConfigManager.limitConfigValue
    }
    
    var usageLeftOsb: Observable<Int> {
        modelManager.usageLeftOsb
    }
    
    var usageLeftValue: Int {
        modelManager.usageLeftValue
    }
    
    var genWhenRwDismissCreateOsb: Observable<Bool> {
        modelManager.genWhenRwDismissCreateOsb
    }
    
    var genWhenRwDismissCreateValue: Bool {
        modelManager.genWhenRwDismissCreateValue
    }
    
    var cancelGenOsb: Observable<Bool> {
        modelManager.cancelGenOsb
    }
    
    var cancelGenValue: Bool {
        modelManager.cancelGenValue
    }
}

extension CreateViewModel {
    func updateCancelGenView(stopGen: Bool) {
        modelManager.updateCancelGenView(cancel: stopGen)
    }
    
    func updateGenWhenRwCreateDismiss(isGen: Bool) {
        modelManager.updateGenWhenRwCreateDismiss(isGen: isGen)
    }
    
    func defaultError(message: String = "Something went wrong. Please try again!") -> Error {
        let defaultError = NSError(domain: "", code: 123, userInfo: [NSLocalizedDescriptionKey: message])
        return defaultError
    }
    
    // Update max creation
    func updateMaxCreationRwAd() {
        guard !userDefault.isPurchase && userDefault.adsConfig.maxCreation > 0 && usageLeftValue == 0 && Developer.isGenArtByAd else { return }
        print("===> Update max creation: \(userDefault.adsConfig.maxCreation)")
        userDefault.adsConfig.maxCreation -= 1
    }
    
    // Update usage
    func updateUsage() {
        if userDefault.isPurchase {
            userDefault.usage.usagePremiumCount += 1
        } else {
            userDefault.usage.usageFreeCount += 1
        }
        // Update usage left
        modelManager.updateUsageLeft()
    }
    
    func checkGen(loadingView: NVActivityIndicatorView,
                  viewController: UIViewController,
                  popupUsageEnough: @escaping () -> Void,
                  requestGen: @escaping () -> Void,
                  openDsLimit: @escaping () -> Void,
                  showRwPopup: @escaping () -> Void) {
        
        let userDefault = UserDefaultService.shared
        let remoteConfig = RemoteConfigManagerImpl.shared
        let adsManager = AdsManager.shared
        let freeUsage = remoteConfig.freeUsageConfigValue
        let usageLeft = usageLeftValue
        let usage = userDefault.usage
        
        print("Log GEN VALUE:  free usage: \(freeUsage) - usageLeft: \(usageLeft) - usage: \(usage)")
        
        if userDefault.isPurchase {
            guard usageLeft > 0 else {
                // bung popup enough
                loadingView.stopAnimating()
                popupUsageEnough()
                return
            }
            loadingView.stopAnimating()
            requestGen()
        } else {
            if usageLeft > 0 {
                // Còn usageLeft (free usage) => Gen art
                loadingView.stopAnimating()
                requestGen()
            } else {
                // Hết usageLeft => logic max creation
                // Check max creation với rewarded ad
                if adsManager.adsConfigValue.rewarded.enable && userDefault.adsConfig.maxCreation > 0 {
                    // Còn được gen với rw ad => show popup rw
                    loadingView.stopAnimating()
                    showRwPopup()
                } else {
                    // Hết lượt gen với rw ad - show ds
                    loadingView.stopAnimating()
                    openDsLimit()
                }
            }
        }
    }
    
    // Request flux
    func requestFlux(userInput: String, controlImage: String, styleModel: StyleConfigModel) -> Observable<String> {
        Observable<String>.create { [weak self] observer in
            let disposable = Disposables.create()
            guard let owner = self else {
                observer.onCompleted()
                return disposable
            }
            APIClient.requestFlux(userInput: userInput, controlImage: controlImage, styleModel: styleModel) { result, error  in
                if let error = error {
                    owner.apiRequestTracking(isSuccess: false, nameRequest: .create)
                    observer.onError(error)
                    observer.onCompleted()
                } else if let result = result {
                    owner.apiRequestTracking(isSuccess: true, nameRequest: .create)
                    observer.onNext(result)
                    observer.onCompleted()
                }
            }
            return disposable
        }
    }
    
    // MARK: Polling get art
    func getReplicateResultStringOutput(url: String) -> Observable<ReplicateResultStringOutput> {
        Observable<ReplicateResultStringOutput>.create { [weak self] observer in
            let disposable = Disposables.create()
            
            guard let wSelf = self else {
                observer.onCompleted()
                return disposable
            }
            
            APIClient.getResultReplicate(url: url) { (result: ReplicateResultStringOutput?, error) in
                if let error = error {
                    observer.onError(error)
                    observer.onCompleted()
                } else if let response = result {
                    observer.onNext(response)
                    observer.onCompleted()
                }
            }
            return disposable
        }
    }
    
    func pollGetReplicateResultStringOutput(url: String) -> Observable<ReplicateResultStringOutput> {
        getReplicateResultStringOutput(url: url).flatMap { response -> Observable<ReplicateResultStringOutput> in
            if response.status == "succeeded" {
                return Observable.just(response)
            } else if response.status == "processing" || response.status == "starting" {
                return Observable<Int>.timer(.seconds(1), scheduler: scheduler.main)
                    .flatMap { _ in self.pollGetReplicateResultStringOutput(url: url) }
            } else {
                return Observable.error(self.defaultError)
            }
        }
    }
    
}

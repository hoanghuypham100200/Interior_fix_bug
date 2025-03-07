import Foundation
import UIKit
import RxSwift
import RxCocoa

class OnboardingViewModel: BaseViewModel {
    
    static let shared: OnboardingViewModel = .init()
    
    private var remoteConfigManager: RemoteConfigManager {
        RemoteConfigManagerImpl.shared
    }
    
    var obConfigObservable: Observable<String> {
        remoteConfigManager.obConfigOsb
    }
    
    var obConfigValue: String {
        remoteConfigManager.obConfigValue
    }
}

extension OnboardingViewModel {
    
    func getOnboardingDataOsb(version: OnboardingType) -> Observable<[OnboardingItem]> {
        Observable<[OnboardingItem]>.create { [weak self] observer in
            let disposable = Disposables.create()
            guard let _ = self else {
                observer.onCompleted()
                return disposable
            }
            
            JsonService.shared.getDataOnboarding(versionID: version) { data in
                if let data = data {
                    observer.onNext(data)
                    observer.onCompleted()
                } else {
                    observer.onCompleted()
                }
            }
            
            return disposable
        }
    }
}

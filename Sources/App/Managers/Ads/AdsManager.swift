import Foundation
import UIKit
import RxSwift
import RxCocoa

class AdsManager: BaseViewModel {
    
    static let shared: AdsManager = .init()
    
    private var remoteConfigManager: RemoteConfigManager {
        RemoteConfigManagerImpl.shared
    }
    
    // ads
    var adsConfigOsb: Observable<AdsConfigModel> {
        remoteConfigManager.adsConfigOsb
    }
    
    var adsConfigValue: AdsConfigModel {
        remoteConfigManager.adsConfigValue
    }
}

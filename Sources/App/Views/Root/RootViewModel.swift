import RxSwift
import Foundation

class RootViewModel: BaseViewModel {
    
    static let shared = RootViewModel.init()
    
    private var remoteConfigManager: RemoteConfigManager {
        RemoteConfigManagerImpl.shared
    }
    
    // did get all value from rc
    var didGetConfigOsb: Observable<Bool> {
        remoteConfigManager.didGetConfigOsb
    }
    
    var didGetConfigValue: Bool {
        remoteConfigManager.didGetConfigValue
    }
}

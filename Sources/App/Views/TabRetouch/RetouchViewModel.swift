import Foundation
import NVActivityIndicatorView
import RxSwift
import UIKit

class RetouchViewModel: BaseViewModel {
    
    static let shared = RetouchViewModel.init()
    private let userDefault = UserDefaultService.shared
    
    let defaultError = NSError(domain: "", code: 123, userInfo: [NSLocalizedDescriptionKey: "Something went wrong. Please try again!"])
    
    private var modelManager: ModelManager {
        ModelManagerImpl.shared
    }
    
    private var remoteConfigManager: RemoteConfigManager {
        RemoteConfigManagerImpl.shared
    }
    
    var exampleConfigOsb: Observable<[ExampleRetouchModel]> {
        remoteConfigManager.exampleConfigOsb
    }
    
    var exampleConfigValue: [ExampleRetouchModel] {
        remoteConfigManager.exampleConfigValue
    }
    
    
    var usageLeftOsb: Observable<Int> {
        modelManager.usageLeftOsb
    }
    
    var usageLeftValue: Int {
        modelManager.usageLeftValue
    }
  
}

extension CreateViewModel {
   
   
}


import Foundation
import UIKit
import RxSwift
import RxCocoa

class APIManager: BaseViewModel {
    
    static let shared: APIManager = .init()
    
    private var remoteConfigManager: RemoteConfigManager {
        RemoteConfigManagerImpl.shared
    }

    // is using local key
    var isUsingLocalKeyOsb: Observable<Bool> {
        remoteConfigManager.isUsingLocalKeyOsb
    }
    
    var isUsingLocalKeyValue: Bool {
        remoteConfigManager.isUsingLocalKeyValue
    }
    
    // api endpoint
    var apiEndpointOsb: Observable<APIEndPointModel> {
        remoteConfigManager.apiEndpointOsb
    }
    
    var apiEndpointValue: APIEndPointModel {
        remoteConfigManager.apiEndpointValue
    }
    
    // api key
    var apiKeyOsb: Observable<String> {
        remoteConfigManager.apiKeyOsb
    }
    
    var apiKeyValue: String {
        remoteConfigManager.apiKeyValue
    }
    
    var fluxModelConfigOsb: Observable<FluxConfigModel> {
        remoteConfigManager.fluxModelConfigOsb
    }
    
    var fluxModelConfigValue: FluxConfigModel {
        remoteConfigManager.fluxModelConfigValue
    }
    
    var fluxFillDevModelConfigValue: FluxFillDevConfigModel {
        remoteConfigManager.fluxFillDevModelConfigValue
    }
}

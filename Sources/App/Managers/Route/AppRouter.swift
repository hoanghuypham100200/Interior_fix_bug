import Foundation
import UIKit

final class AppRouter {
    
    // Direct store main. Truyền vào value: tabbar, ad, option, profile, ...
    static func makeDirectStoreMain(value: String) -> UIViewController {
        let dsReleaseVC = pickDS()
        dsReleaseVC.modalPresentationStyle = .fullScreen
        dsReleaseVC.value = value
        return dsReleaseVC
    }
    
    // Direct store launch
    static func makeDirectStoreLaunch() -> UIViewController {
        let dsReleaseVC = pickDS()
        dsReleaseVC.modalPresentationStyle = .fullScreen
        dsReleaseVC.isObLaunch = true
        dsReleaseVC.value = Value.launch.rawValue
        dsReleaseVC.event = Event.ds_launch.rawValue
        dsReleaseVC.eventPurchased = Event.ds_launch_purchased.rawValue
        return dsReleaseVC
    }
    
    // Direct store onboarding
    static func makeDirectStoreOnboarding() -> UIViewController {
        let dsReleaseVC = pickDS()
        dsReleaseVC.modalPresentationStyle = .fullScreen
        dsReleaseVC.isObLaunch = true
        dsReleaseVC.value = Value.onboarding.rawValue
        dsReleaseVC.event = Event.ds_onboarding.rawValue
        dsReleaseVC.eventPurchased = Event.ds_onboarding_purchased.rawValue
        return dsReleaseVC
    }
    
    static func pickDS() -> DirectStoreBaseViewController {
        #if DEBUG
        return DirectStoreV3ViewController()
        #else
        let dsType = UserDefaultService.shared.dsConfig.type
        switch dsType {
        case DirectStoreType.directstoreV1.rawValue:
            return DirectStoreV1ViewController()
        case DirectStoreType.directstoreV2.rawValue:
            return DirectStoreV2ViewController()
        default:
            return DirectStoreV1ViewController()
        }
        #endif
    }
    
    static func makeSettingViewController() -> UIViewController {
        let settingVC = SettingViewController()
        return settingVC
    }
}


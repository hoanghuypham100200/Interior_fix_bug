import Foundation
import UIKit

final class AppRouter {

    static func makeDirectStore(eventFunc: Event, eventFuncPurchased: Event, valueGeneral: Value) -> UIViewController {
        
        let dsType = UserDefaultService.shared.dsConfig.type
        
        // Code review: tạo enum cho ds type
        switch dsType {
        case "directstore-v2":
            let dsVC = DirectStoreV2ViewController()
            dsVC.modalPresentationStyle = .fullScreen
            dsVC.eventFunc = eventFunc.rawValue
            dsVC.eventFuncPurchased = eventFuncPurchased.rawValue
            dsVC.valueGeneral = valueGeneral.rawValue
            return dsVC
        case "directstore-v3":
            let dsVC = DirectStoreV3ViewController()
            dsVC.modalPresentationStyle = .fullScreen
            dsVC.eventFunc = eventFunc.rawValue
            dsVC.eventFuncPurchased = eventFuncPurchased.rawValue
            dsVC.valueGeneral = valueGeneral.rawValue
            return dsVC
        default:
            let dsVC = DirectStoreV1ViewController()
            dsVC.modalPresentationStyle = .fullScreen
            dsVC.eventFunc = eventFunc.rawValue
            dsVC.eventFuncPurchased = eventFuncPurchased.rawValue
            dsVC.valueGeneral = valueGeneral.rawValue
            return dsVC
        }
    }
}

import Foundation
import FirebaseAnalytics

enum Event: String {
    
    // MARK: First open
    case tl_first_open
    
    // MARK: DS + IAP
    case ds_limit
    case ds_limit_purchased
    case ds_onboarding
    case ds_onboarding_purchased
    case ds_launch
    case ds_launch_purchased
    
    case api_request
    case create
    
}

enum Param: String {
    case value
    case page
    case item_id
    case type
}

enum Value: String {
    case onboarding
    case launch
    case open   // become active
    case header
    case ad
    case allChapter
    case create
    case style
    
    // api request
    case success
    case fail
}

final class AnalyticService {
    
    static func logEvent(_ event: Event) {
        #if DEBUG
        #else
        Analytics.logEvent(event.rawValue, parameters: nil)
        print("EVENT TRACKING: ====> EVEN: \(event)")
        #endif
    }
    
    static func logEventMain(event: String, listParameters: Dictionary<String, Any>) {
        #if DEBUG
        #else
        Analytics.logEvent(event, parameters: listParameters)
        print("EVENT TRACKING: ====> EVEN: \(event) ====> PARAM: \(listParameters)")
        #endif
    }
}

import UIKit

class DirectStoreBaseViewController: BaseViewController {
    // value from before screen, track event
    var value = ""
    var page = ""
    var type = ""
    // track onboarding or launch
    var event = ""
    var eventPurchased = ""
    
    var isObLaunch = false // biến này để check khi là mode của ob launch.
}

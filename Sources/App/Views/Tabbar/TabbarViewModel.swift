import Foundation
import RxSwift

class TabbarViewModel: BaseViewModel {
    
    static let shared = TabbarViewModel.init()
    
    private let modelManager = ModelManagerImpl.shared
    
    var showRwPopupCreateOsb: Observable<Bool> {
        modelManager.showRwPopupCreateOsb
    }
    
    var showRwPopupCreateValue: Bool {
        modelManager.showRwPopupCreateValue
    }
    
    var showProccessingViewOsb: Observable<Bool> {
        modelManager.showProccessingViewOsb
    }
    
    var showProccessingViewValue: Bool {
        modelManager.showProccessingViewValue
    }
  
}

extension TabbarViewModel {
    // update show rw popup
    func updateShowRwPopupCreate(isShow: Bool) {
        modelManager.updateShowRwPopupCreate(isShow: isShow)
    }
    
    func updateShowProccessingView(isShow: Bool) {
        modelManager.updateShowProccessingView(isShow: isShow)
    }
}

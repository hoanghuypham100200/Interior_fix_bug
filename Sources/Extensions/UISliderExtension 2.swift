import Foundation
import UIKit

extension UISlider {
    
    func configDefaultSlider(enable: Bool = true) {
        self.maximumTrackTintColor = AppColor.maxTrack.withAlphaComponent(0.2)
        self.minimumTrackTintColor = AppColor.newMain.withAlphaComponent(enable ? 1 : 0.4)
        self.setThumbImage(R.image.icon_knob(), for: .normal)
        self.dropShadow(color: .black, opacity: 0.12, offet: CGSize(width: 0, height: 0.5), radius: 4)
        self.dropShadow(color: .black, opacity: 0.12, offet: CGSize(width: 0, height: 6), radius: 13)
        self.isUserInteractionEnabled = enable
    }
}

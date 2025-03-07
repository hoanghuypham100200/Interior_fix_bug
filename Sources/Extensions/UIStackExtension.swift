import UIKit

extension UIStackView {
    
    func addTopBottomPadding(top: Int = 20, bottom: Int = 20) {
        self.isLayoutMarginsRelativeArrangement = true
        self.layoutMargins = UIEdgeInsets(top: top.scaleX, left: 0, bottom: bottom.scaleX, right: 0)
    }
    
    func removeTopBottomPadding() {
        self.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func setupSetting() {
        self.layer.masksToBounds = true
        self.axis = .vertical
        self.backgroundColor = AppColor.bg_2
//        self.dropMainShadow()
        self.cornerRadius = 15.scaleX
        self.clipsToBounds = false
    }
    
    func removeStackSubView() {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
        self.removeTopBottomPadding()
    }
}

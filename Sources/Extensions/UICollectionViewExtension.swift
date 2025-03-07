import Foundation
import UIKit

extension UICollectionView {
    func setupCollectionView() {
        self.allowsMultipleSelection = false
        self.backgroundColor = .clear
        self.backgroundView = UIView(frame: CGRect.zero)
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
    }
}


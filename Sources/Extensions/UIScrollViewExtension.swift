import UIKit

extension UIScrollView {
    
    func scrollToTop(animated: Bool) {
        let topOffset = CGPoint(x: 0, y: -self.contentInset.top)
        self.setContentOffset(topOffset, animated: animated)
    }
    
    func scrollToBottom(animated: Bool) {
        if self.contentSize.height < self.bounds.size.height { return }
        let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height)
        self.setContentOffset(bottomOffset, animated: animated)
    }
}

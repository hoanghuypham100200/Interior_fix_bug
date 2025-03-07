import Foundation
import UIKit

class AlignLeftFlowLayout: UICollectionViewFlowLayout {
    
    var maximumCellSpacing: CGFloat = 10
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributesToReturn = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        
        for attributes in attributesToReturn {
            if attributes.representedElementKind == nil {
                if let newAttributes = layoutAttributesForItem(at: attributes.indexPath) {
                    attributes.frame = newAttributes.frame
                }
            }
        }
        
        return attributesToReturn
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let curAttributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes else {
            return nil
        }
        
        guard let collectionViewFlowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout else {
            return nil
        }
        
        let sectionInset = collectionViewFlowLayout.sectionInset
        
        if indexPath.item == 0 {
            let frame = curAttributes.frame
            curAttributes.frame = CGRect(x: sectionInset.left, y: frame.origin.y, width: frame.size.width, height: frame.size.height)
            return curAttributes
        }
        
        let prevIndexPath = IndexPath(item: indexPath.item - 1, section: indexPath.section)
        guard let prevFrame = layoutAttributesForItem(at: prevIndexPath)?.frame else {
            return nil
        }
        
        let prevFrameRightPoint = prevFrame.origin.x + prevFrame.size.width + maximumCellSpacing
        
        let curFrame = curAttributes.frame
        let stretchedCurFrame = CGRect(x: 0, y: curFrame.origin.y, width: collectionView!.frame.size.width, height: curFrame.size.height)
        
        if prevFrame.intersects(stretchedCurFrame) {
            curAttributes.frame = CGRect(x: prevFrameRightPoint, y: curFrame.origin.y, width: curFrame.size.width, height: curFrame.size.height)
        } else {
            curAttributes.frame = CGRect(x: sectionInset.left, y: curFrame.origin.y, width: curFrame.size.width, height: curFrame.size.height)
        }
        
        return curAttributes
    }
}

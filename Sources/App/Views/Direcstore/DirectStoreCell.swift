import Foundation
import SnapKit
import UIKit

class DirectStoreCell: BaseCollectionViewCell {
    
    private lazy var dsImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        dsImageView.contentMode = .scaleAspectFit
    }
    
    private func setupConstraints() {
        contentView.addSubview(dsImageView)
        
        dsImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func update(image: String) {
        dsImageView.image = UIImage(named: image)
    }
}

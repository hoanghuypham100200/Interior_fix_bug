import Foundation
import SnapKit
import UIKit

class OnboardingV1Cell: BaseCollectionViewCell {
    private lazy var thumbImageView = UIImageView()
  
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
   
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        contentView.backgroundColor = AppColor.line_ob
        
        thumbImageView.contentMode = .scaleAspectFill
        
    }
    
    private func setupConstraints() {
        addSubview(thumbImageView)
        
        thumbImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(852.scaleX)
        }
        
    }
    
    public func update(obModel:OnboardingItem) {
        thumbImageView.image = UIImage(named: obModel.thumb)
    }
}

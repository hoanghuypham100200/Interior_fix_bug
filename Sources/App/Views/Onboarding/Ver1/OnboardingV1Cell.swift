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
                
    }
    
    private func setupConstraints() {
        addSubview(thumbImageView)
        
        thumbImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(60)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(536.scaleX)
        }
        
    }
    
    public func update(obModel:OnboardingItem, updateImage:Bool) {
        thumbImageView.image = UIImage(named: obModel.thumb)
        
        if(updateImage) {
            thumbImageView.snp.updateConstraints {
                $0.top.equalToSuperview().inset(60)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(634.scaleX)
            }
        }
    }
}

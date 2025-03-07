import Foundation
import SnapKit
import UIKit

class TabbarHeader: UIView {
    private lazy var titleLabel = UILabel()
    public lazy var premiumButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        titleLabel.setText(text: "interior.ai", color: AppColor.text_black)
        titleLabel.font = UIFont.appFont(size: 28)
        
        premiumButton.setupPremiumButton()

    }
    
    private func setupConstraints() {
        addSubview(titleLabel)
        addSubview(premiumButton)
        
        premiumButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20.scaleX)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 74.scaleX, height: 40.scaleX))
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(premiumButton)
            $0.leading.equalToSuperview().inset(20.scaleX)
        }
    }
    
    public func checkPurchase(isPurchase: Bool) {
        premiumButton.isHidden = isPurchase
    }
    
}


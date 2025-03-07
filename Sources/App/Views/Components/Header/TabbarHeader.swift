import Foundation
import SnapKit
import UIKit

class TabbarHeader: UIView {
    private lazy var titleLabel = UILabel()
    public lazy var premiumButton = UIButton()
    public lazy var galleryButton = UIButton()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        titleLabel.setText(text: "Interior", color: AppColor.text_black)
        titleLabel.font = UIFont.appFont(size: 24)
        
        premiumButton.setupPremiumButton()
        galleryButton.setupImageButton(icon: R.image.icon_unknow(), iconColor: UIColor.white, bgColor: AppColor.text_black, corner: 20)
    }
    
    private func setupConstraints() {
        addSubview(titleLabel)
        addSubview(premiumButton)
        addSubview(galleryButton)
        
        premiumButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16.scaleX)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 80.scaleX, height: 40.scaleX))
        }
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        galleryButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16.scaleX)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 40.scaleX, height: 40.scaleX))
        }
    }
    
    public func checkPurchase(isPurchase: Bool) {
        premiumButton.isHidden = isPurchase
    }
    
    public func setupHeaderRetouch() {
        galleryButton.isHidden = true
        titleLabel.textColor = .white
    }
    
}


import Foundation
import SnapKit
import UIKit

class TabbarHeaderView: UIView {
    
    private lazy var logoImageView = UIImageView()
    private lazy var lineView = UIView()
    public lazy var premiumButton = UIButton()
    public lazy var settingButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        logoImageView.image = R.image.logo_header()
        logoImageView.contentMode = .scaleAspectFit
        
        lineView.backgroundColor = AppColor.mainGrey

        premiumButton.setImage(R.image.icon_premium(), for: .normal)
        settingButton.setImage(R.image.icon_setting(), for: .normal)
    }
    
    private func setupConstraints() {
        addSubview(logoImageView)
        addSubview(premiumButton)
        addSubview(settingButton)
        addSubview(lineView)
        
        logoImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20.scaleX)
            $0.centerY.equalTo(settingButton)
            $0.size.equalTo(CGSize(width: 45.scaleX, height: 33.scaleX))
        }
        
        premiumButton.snp.makeConstraints {
            $0.trailing.equalTo(settingButton.snp.leading).inset(-5.scaleX)
            $0.centerY.equalTo(settingButton)
            $0.size.equalTo(settingButton)
        }
        
        settingButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(15.scaleX)
            $0.top.equalToSuperview()
            $0.size.equalTo(CGSize(width: 40.scaleX, height: 40.scaleX))
        }
        
        lineView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(settingButton.snp.bottom)
            $0.height.equalTo(1.scaleX)
        }
    }
    
    public func checkPremium(isPremium: Bool) {
        premiumButton.isHidden = isPremium
    }
}

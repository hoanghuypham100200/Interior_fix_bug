import Foundation
import SnapKit
import UIKit

class RewardedAdOptionView: UIView {
    
    private lazy var appNameView = UIView()
    private lazy var appNameLabel = UILabel()
    private lazy var proIcon = UIImageView()
    
    private lazy var unlimitView = UIView()
    private lazy var unlimitIcon = UIImageView()
    private lazy var unlimitLabel = UILabel()
    
    private lazy var desLabel = UILabel()
    public lazy var premiumButton = UIButton()
    public lazy var watchAdButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        self.cornerRadius = 25.scaleX
        self.clipsToBounds = true
        self.backgroundColor = AppColor.guBg
        
        appNameLabel.setText(text: "ArchAI", color: AppColor.guMain)
        appNameLabel.font = .systemFont(ofSize: 32, weight: .bold)
        
        proIcon.setIcon(icon: R.image.icon_pro_popup())
        
        unlimitIcon.setIcon(icon: R.image.icon_unlimit())
        
        unlimitLabel.setText(text: "Unlimited use", color: AppColor.guMain)
        unlimitLabel.font = .systemFont(ofSize: 18, weight: .medium)
        
        desLabel.setText(text: "Do you want to get premium\nfor unlimited use instead?", color: AppColor.guMain)
        desLabel.font = .systemFont(ofSize: 14, weight: .medium)
        desLabel.numberOfLines = 0
        desLabel.textAlignment = .center

        premiumButton.setupTitleIconButton(title: "Get Premium", fontWeight: .bold, fontSize: 16, titleColor: AppColor.guMain, icon: UIImage(systemName: "crown.fill"), iconColor: AppColor.guMain, padding: 5, bgColor: AppColor.guPremium, radius: 25)
        watchAdButton.setupTitleButton(title: "Watch Ad", fontWeight: .bold, fontSize: 16, titleColor: AppColor.guMain, bgColor: AppColor.guBg1, radius: 25)
    }
    
    private func setupConstraints() {
        addSubview(appNameView)
        appNameView.addSubview(appNameLabel)
        appNameView.addSubview(proIcon)
        addSubview(unlimitView)
        unlimitView.addSubview(unlimitIcon)
        unlimitView.addSubview(unlimitLabel)
        addSubview(desLabel)
        addSubview(premiumButton)
        addSubview(watchAdButton)
        
        appNameView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(20.scaleX)
        }
        
        appNameLabel.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
        }
        
        proIcon.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
            $0.leading.equalTo(appNameLabel.snp.trailing).inset(-10.scaleX)
            $0.size.equalTo(CGSize(width: 57.scaleX, height: 37.scaleX))
        }
        
        unlimitView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(appNameView.snp.bottom).inset(-20.scaleX)
        }
        
        unlimitIcon.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.size.equalTo(CGSize(width: 20.scaleX, height: 20.scaleX))
        }
        
        unlimitLabel.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
            $0.leading.equalTo(unlimitIcon.snp.trailing).inset(-10.scaleX)
        }
        
        desLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(unlimitView.snp.bottom).inset(-10.scaleX)
        }
        
        premiumButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(45.scaleX)
            $0.top.equalTo(desLabel.snp.bottom).inset(-20.scaleX)
            $0.height.equalTo(50.scaleX)
        }
        
        watchAdButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(45.scaleX)
            $0.top.equalTo(premiumButton.snp.bottom).inset(-15.scaleX)
            $0.bottom.equalToSuperview().inset(25.scaleX)
            $0.height.equalTo(50.scaleX)
        }
    }
}

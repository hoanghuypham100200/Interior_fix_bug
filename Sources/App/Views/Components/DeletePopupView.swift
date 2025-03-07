import Foundation
import SnapKit
import UIKit

class DeletePopupView: UIView {
    private lazy var titleLabel = UILabel()
    private lazy var descriptionLabel = UILabel()
    public lazy var closeButton = UIButton()
    private lazy var centerView = UIView()
    public lazy var sureButton = UIButton()
    public lazy var noButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        layer.cornerRadius = 8
        backgroundColor = AppColor.bg_1
        
        titleLabel.setText(text: "Confirm Delete", color: AppColor.text_black_patriona)
        titleLabel.font = UIFont.appFont(size: 24)
        
        descriptionLabel.setText(text: "Do you really want to delete this?", color: AppColor.text_black_patriona)
        descriptionLabel.font = .systemFont(ofSize: 14, weight: .medium)
        
        closeButton.setSystemIcon("xmark", pointSize: 16, weight: .semibold)
        closeButton.imageView?.contentMode = .scaleAspectFit
        
        sureButton.setupTitleButton(title: "Sure", fontWeight: .medium, fontSize: 16, titleColor: AppColor.text_black, bgColor: AppColor.bg_1, radius: 20)
        sureButton.layer.borderWidth = 2.scaleX
        sureButton.layer.borderColor = AppColor.text_black_patriona.cgColor
        
        noButton.setupTitleButton(title: "No", fontWeight: .medium, fontSize: 16, titleColor: AppColor.text_black, bgColor: AppColor.yellow_normal_hover, radius: 20)
       
    }
    
    private func setupConstraints() {
       addSubview(closeButton)
       addSubview(titleLabel)
       addSubview(descriptionLabel)
       addSubview(centerView)
       centerView.addSubview(sureButton)
       centerView.addSubview(noButton)
        
        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24.scaleX)
            $0.trailing.equalToSuperview().inset(24.scaleX)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(closeButton.snp.bottom).inset(-8.scaleX)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).inset(-12.scaleX)
            $0.centerX.equalToSuperview()
        }
        
        centerView.snp.makeConstraints {
            $0.height.equalTo(54.scaleX)
            $0.top.equalTo(descriptionLabel.snp.bottom).inset(-36.scaleX)
            $0.centerX.equalToSuperview()
        }
        
        sureButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 123.scaleX, height: 54.scaleX))
        }
        
        noButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(sureButton.snp.trailing).inset(-10.scaleX)
            $0.size.equalTo(CGSize(width: 123.scaleX, height: 54.scaleX))
        }
    }
}


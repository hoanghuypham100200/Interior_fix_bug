import Foundation
import SnapKit
import UIKit

class PopupContainerView: UIView {
    public lazy var titleLabel = UILabel()
    public lazy var descriptionLabel = UILabel()
    public lazy var centerView = UIView()
    public lazy var rightButton = UIButton()
    public lazy var leftButton = UIButton()
    
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
        backgroundColor = .white
        
        titleLabel.font = UIFont.appFont(size: 24)

        descriptionLabel.font = .systemFont(ofSize: 14, weight: .medium)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
    }
    
    private func setupConstraints() {
       addSubview(titleLabel)
       addSubview(descriptionLabel)
       addSubview(centerView)
       centerView.addSubview(rightButton)
        centerView.addSubview(leftButton)
        
 
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20.scaleX)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).inset(-20.scaleX)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(300.scaleX)
        }
        
        centerView.snp.makeConstraints {
            $0.height.equalTo(55.scaleX)
            $0.top.equalTo(descriptionLabel.snp.bottom).inset(-20.scaleX)
            $0.centerX.equalToSuperview()
        }
        
        rightButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 144.scaleX, height: 55.scaleX))
        }
        
        leftButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(rightButton.snp.leading).inset(-10.scaleX)
            $0.size.equalTo(CGSize(width: 144.scaleX, height: 55.scaleX))
        }
    }
}


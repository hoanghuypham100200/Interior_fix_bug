

import UIKit
import SnapKit

class TitleDSView: UIView {
    private lazy var nameAppFlameView = UIView()
    private lazy var iconImageView = UIImageView()
    private lazy var nameAppLabel = UILabel()
    private lazy var titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        iconImageView.image = R.image.ic_pro()
        iconImageView.contentMode = .scaleAspectFill
        
        nameAppLabel.setText(text: "Interior", color: AppColor.text_black)
        nameAppLabel.font = UIFont.appFont(size: 40)
        
        titleLabel.text = "Unlock Premium Home"
        titleLabel.textColor = AppColor.text_black
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .regular)
    }
    
    private func setupConstraints() {
        addSubview(nameAppFlameView)
        addSubview(titleLabel)
        nameAppFlameView.addSubview(nameAppLabel)
        nameAppFlameView.addSubview(iconImageView)
        
        nameAppFlameView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.equalTo(46.scaleX)
        }
        
        nameAppLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 54.scaleX, height: 37.scaleX))
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.leading.equalTo(nameAppLabel.snp.trailing).inset(-10.scaleX)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(nameAppFlameView.snp.bottom).inset(-5.scaleX)
            $0.centerX.equalToSuperview()
        }
    }
    
  
}

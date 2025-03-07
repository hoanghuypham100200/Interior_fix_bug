import Foundation
import UIKit
import SnapKit

class ChooseButton: UIButton {
    private lazy var centerView = UIView()
    private lazy var rightTitleLabel = UILabel()
    private lazy var iconImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        self.backgroundColor = AppColor.bg_ds
        self.cornerRadius = 15.scaleX
        self.clipsToBounds = true
        
        centerView.isUserInteractionEnabled = false
        
        
        iconImageView.contentMode = .scaleAspectFit
    }
    
    private func setupConstraints() {
        addSubview(centerView)
        centerView.addSubview(rightTitleLabel)
        centerView.addSubview(iconImageView)
        
        centerView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 21.scaleX, height: 21.scaleX))
        }
        
        rightTitleLabel.snp.makeConstraints {
            $0.trailing.centerY.equalToSuperview()
            $0.leading.equalTo(iconImageView.snp.trailing).inset(-5.scaleX)
        }
    }
    
    public func baseSetup(color: UIColor, title: String, icon: String, weight: UIImage.SymbolWeight = .medium, textSize: Int) {
        rightTitleLabel.setText(text: title, color: color)
        rightTitleLabel.font = .systemFont(ofSize: CGFloat(textSize), weight: .semibold)
        iconImageView.setIconSystem(name: icon, color: AppColor.text_black, weight: weight, sizeIcon: textSize)
        

        
    }
}

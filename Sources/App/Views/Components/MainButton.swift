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
        self.backgroundColor = AppColor.bg_view_1
        self.cornerRadius = 20.scaleX
        self.layer.borderColor = AppColor.line_ob.cgColor
        self.layer.borderWidth = 1
        self.clipsToBounds = true
        
        centerView.isUserInteractionEnabled = false
        
        rightTitleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        
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
            $0.size.equalTo(CGSize(width: 24.scaleX, height: 19.scaleX))
        }
        
        rightTitleLabel.snp.makeConstraints {
            $0.trailing.centerY.equalToSuperview()
            $0.leading.equalTo(iconImageView.snp.trailing).inset(-5.scaleX)
        }
    }
    
    public func baseSetup(color: UIColor, title: String, icon:String, weight: UIImage.SymbolWeight = .medium) {
        rightTitleLabel.setText(text: title, color: color)
        iconImageView.setIconSystem(name: icon, color: AppColor.text_black, weight: weight)
    }
}

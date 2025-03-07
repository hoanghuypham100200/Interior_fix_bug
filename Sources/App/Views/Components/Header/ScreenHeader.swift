import Foundation
import SnapKit
import UIKit

class ScreenHeader: UIView {
    public lazy var backButton = UIButton()
    private lazy var titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        backButton.setImage(R.image.img_back(), for: .normal)
        backButton.imageView?.contentMode = .scaleAspectFit
        
        titleLabel.textColor = AppColor.text_black_patriona
        titleLabel.font = UIFont.appFont(size: 28)
    }
    
    private func setupConstraints() {
        addSubview(backButton)
        addSubview(titleLabel)
        
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20.scaleX)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 40.scaleX, height: 40.scaleX))
        }
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    public func update(title: String) {
        titleLabel.text = title
    }
}

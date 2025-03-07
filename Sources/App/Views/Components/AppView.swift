import Foundation
import SnapKit
import UIKit

class AppView: UIView {

    public lazy var changeIconButton = UIButton()
    private lazy var iconStar = UIImageView()
    private lazy var changeIconLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
//        self.dropMainShadow()
        self.backgroundColor = AppColor.bg_2
        self.cornerRadius = 15.scaleX
        self.clipsToBounds = false
        
        iconStar.setIcon(icon: RImage.icon_setting_star())
        
        changeIconLabel.setText(text: "Change app icon", color: AppColor.text_black)
        changeIconLabel.font = .systemFont(ofSize: 16)
    }
    
    private func setupConstraints() {
        addSubview(changeIconButton)
        changeIconButton.addSubview(iconStar)
        changeIconButton.addSubview(changeIconLabel)
        
        changeIconButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(60.scaleX)
        }
        
        iconStar.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16.scaleX)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 20.scaleX, height: 20.scaleX))
        }
        
        changeIconLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(iconStar.snp.trailing).inset(-12.scaleX)
        }
    }
}

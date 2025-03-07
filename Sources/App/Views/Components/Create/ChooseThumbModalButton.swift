import Foundation
import RxSwift
import SnapKit
import UIKit

class ChooseThumbModalButton: UIView {
    private lazy var linearView = UIView()
    private lazy var centerView = UIView()
    private lazy var titleLabel = UILabel()
    private lazy var iconImageView = UIImageView()
    public lazy var  button = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        linearView.setupGradient(colors: [AppColor.linear_start.cgColor, AppColor.linear_end.cgColor], locations: [0, 1.0], start: CGPoint(x: 0.5, y: 0), end: CGPoint(x: 0.5, y: 1.0))
    }
    
    private func setupViews() {
        layer.cornerRadius = 15.scaleX
        clipsToBounds = true
        
        titleLabel.textColor = AppColor.text_black
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        
        iconImageView.contentMode = .scaleToFill
    }
    
    private func setupConstraints() {
        addSubview(linearView)
        linearView.addSubview(centerView)
        centerView.addSubview(titleLabel)
        centerView.addSubview(iconImageView)
        linearView.addSubview(button)
        
        linearView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        centerView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 16.scaleX, height: 16.scaleX))
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(iconImageView.snp.bottom).inset(-10.scaleX)
            $0.bottom.equalToSuperview()
        }
        
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    public func baseSetup(title: String, icon:String, weight: UIImage.SymbolWeight = .medium) {
        titleLabel.setText(text: title, color: AppColor.text_black)
        iconImageView.setIconSystem(name: icon, color: AppColor.text_black, weight: weight, sizeIcon: 14)
    }
    
}


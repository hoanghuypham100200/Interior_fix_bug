import Foundation
import SnapKit
import UIKit

class ModalHeader: UIView {
    private lazy var indicatorView = UIView()
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
        indicatorView.cornerRadius = 2.5
        indicatorView.backgroundColor = AppColor.modal_indicator
        
        titleLabel.textColor = AppColor.text_black_patriona
        titleLabel.font =  UIFont.appFont(size: 20)
        titleLabel.textAlignment = .center
    }
    
    private func setupConstraints() {
        addSubview(indicatorView)
        addSubview(titleLabel)
        
        indicatorView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15.scaleX)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 60.scaleX, height: 5))
        }

        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(indicatorView.snp.bottom)
            $0.bottom.equalToSuperview()
        }
    }
    
    public func update(title: String) {
        titleLabel.text = title
    }
}

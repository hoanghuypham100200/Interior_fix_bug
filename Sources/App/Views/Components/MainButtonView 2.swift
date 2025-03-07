import Foundation
import SnapKit
import UIKit

class MainButtonView: UIView {
    
    private lazy var lineView = UIView()
    public lazy var button = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.setMainGradient()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        lineView.backgroundColor = AppColor.line
    }
    
    private func setupConstraints() {
        addSubview(lineView)
        addSubview(button)
        
        lineView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalTo(1.scaleX)
        }
        
        button.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20.scaleX)
            $0.top.equalTo(lineView.snp.bottom).inset(-12.scaleX)
            $0.bottom.equalToSuperview().inset(16.scaleX)
            $0.height.equalTo(55.scaleX)
        }
    }
    
    public func updateTitle(title: String) {
        button.setupImageTextButton(title: title)
    }
}

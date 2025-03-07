import UIKit
import SnapKit

class DescriptionDSView: UIView {
    private lazy var iconImageView = UIImageView()
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
        iconImageView.setSymbol(name: "checkmark.shield.fill", color: AppColor.icon_shield_green, size: 13, weight: .semibold)
        
        titleLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        titleLabel.textColor = AppColor.guMain
    }
    
    private func setupConstraints() {
        addSubview(iconImageView)
        addSubview(titleLabel)
        
        iconImageView.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
            $0.leading.equalTo(iconImageView.snp.trailing).inset(-5.scaleX)
        }
    }
    
    public func changeTrialState(isTrial: Bool) {
        titleLabel.text = isTrial ? "NO PAYMENT NOW" : "CANCEL ANYTIME"
    }
}

import Foundation
import SnapKit
import UIKit

class ButtonDSV2: UIButton {
    private lazy var pickIcon = UIImageView()
    private lazy var productNameLabel = UILabel()
    private lazy var productPriceFrame = UIView()
    private lazy var productPriceLabel = UILabel()
    private lazy var dividedPriceLabel = UILabel()
    
    let dsViewModel = DirectStoreViewModel.shared
    
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
        backgroundColor = AppColor.bg_1
        layer.cornerRadius = 20.scaleX
        
        pickIcon.contentMode = .scaleAspectFit
        
        productNameLabel.textColor = AppColor.yellow_dark
        productNameLabel.font = .systemFont(ofSize: 18)
        
        productPriceFrame.isUserInteractionEnabled = false
        
        productPriceLabel.textColor = AppColor.yellow_dark
        productPriceLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        productPriceLabel.textAlignment = .right
        
        dividedPriceLabel.textAlignment = .right
    }
    
    private func setupConstraints() {
        addSubview(pickIcon)
        addSubview(productNameLabel)
        addSubview(productPriceFrame)
        productPriceFrame.addSubview(dividedPriceLabel)
        productPriceFrame.addSubview(productPriceLabel)
        
        pickIcon.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16.scaleX)
            $0.size.equalTo(CGSize(width: 20.scaleX, height: 20.scaleX))
        }
        
        productNameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(pickIcon.snp.trailing).inset(-12.scaleX)
            $0.trailing.lessThanOrEqualTo(productPriceFrame.snp.leading)
        }
        
        productPriceFrame.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16.scaleX)
        }
        
        dividedPriceLabel.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
        }
        
        productPriceLabel.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(dividedPriceLabel.snp.bottom).inset(-4.scaleX)
        }
    }
    
    public func updateYearly(price: String, weeklyPrice: String, symbol: String) {
        let dividedPrice = dsViewModel.weeklyPerYear(price: weeklyPrice) + symbol
        let devidedAtt = NSMutableAttributedString(string: "\(dividedPrice)",
                                                   attributes: [
                                                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18),
                                                    NSAttributedString.Key.foregroundColor: AppColor.yellow_dark,
                                                    NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
                                                    NSAttributedString.Key.strikethroughColor: AppColor.yellow_dark])
        dividedPriceLabel.attributedText = devidedAtt
        dividedPriceLabel.isHidden = false
        productNameLabel.text = "YEARLY"
        productPriceLabel.text = price + symbol
    }
    
    public func updateWeekly(price: String, symbol: String) {
        productNameLabel.text = "WEEKLY"
        productPriceLabel.text = price + symbol
        dividedPriceLabel.isHidden = true
    }
    
    func updateState(isActive: Bool) {
        layer.borderWidth = isActive ? 4 : 1
        layer.borderColor = isActive ? AppColor.yellow_normal_hover.cgColor : AppColor.bg_3.cgColor
        pickIcon.image = isActive ? R.image.icon_ds_tick_ac() :  R.image.icon_ds_tick_un()
    }
}

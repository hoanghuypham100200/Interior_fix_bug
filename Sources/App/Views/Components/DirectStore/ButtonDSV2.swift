import Foundation
import SnapKit
import UIKit

class ButtonDSV2: UIButton {
    private lazy var pickIcon = UIImageView()
    private lazy var productNameView = UIView()
    private lazy var productNameLabel = UILabel()
    private lazy var dayFreeLabel = UILabel()
    private lazy var bestOfferView = UIView()
    private lazy var productPriceFrame = UIView()
    private lazy var productPriceLabel = UILabel()
    private lazy var dividedPriceLabel = UILabel()
   
    private lazy var titlebestOfferLabel = UILabel()

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
        layer.cornerRadius = 32.scaleX
        
        pickIcon.contentMode = .scaleAspectFit
        
        productNameLabel.textColor = AppColor.text_black
        productNameLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        
        bestOfferView.cornerRadius = 12.scaleX
        bestOfferView.backgroundColor = AppColor.premium
        
        
        productPriceFrame.isUserInteractionEnabled = false
        
        productPriceLabel.textColor = AppColor.text_black
        productPriceLabel.font = .systemFont(ofSize: 20, weight: .regular)
        productPriceLabel.textAlignment = .right
        
        dividedPriceLabel.textAlignment = .right
        
        titlebestOfferLabel.textColor = AppColor.bg_1
        titlebestOfferLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        
        titlebestOfferLabel.text = "BEST OFFER"
        titlebestOfferLabel.textColor = AppColor.text_black
        
        dayFreeLabel.text = "3 days free"
        dayFreeLabel.textColor = AppColor.ds_rtp
        dayFreeLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
    }
    
    private func setupConstraints() {
        addSubview(pickIcon)
        addSubview(productNameView)
        addSubview(productPriceFrame)
        productNameView.addSubview(productNameLabel)
        productNameView.addSubview(dayFreeLabel)
        productNameView.addSubview(bestOfferView)
        bestOfferView.addSubview(titlebestOfferLabel)
        
        productPriceFrame.addSubview(dividedPriceLabel)
        productPriceFrame.addSubview(productPriceLabel)
        
        pickIcon.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20.scaleX)
            $0.size.equalTo(CGSize(width: 20.scaleX, height: 20.scaleX))
        }
        
        productNameView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(pickIcon.snp.trailing).inset(-12.scaleX)
            $0.height.equalTo(44.scaleX)
        }
        
        productNameLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        bestOfferView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 89.scaleX, height: 20.scaleX))
            $0.bottom.leading.equalToSuperview()
        }
        
        dayFreeLabel.snp.makeConstraints {
            $0.bottom.leading.equalToSuperview()
        }
        
        titlebestOfferLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
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
                                                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18,weight: .regular),
                                                    NSAttributedString.Key.foregroundColor: AppColor.ds_rtp,
                                                    NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
                                                    NSAttributedString.Key.strikethroughColor: AppColor.yellow_dark])
        dividedPriceLabel.attributedText = devidedAtt
        dividedPriceLabel.isHidden = false
        productNameLabel.text = "Yearly Access"
        productPriceLabel.text = price + symbol
        bestOfferView.isHidden = false
        dayFreeLabel.isHidden = true
    }
    
    public func updateWeekly(price: String, symbol: String) {
        productNameLabel.text = "Weekly Access"
        productPriceLabel.text = price + symbol
        dividedPriceLabel.isHidden = true
        bestOfferView.isHidden = true
        dayFreeLabel.isHidden = false
    }
    
    func updateState(isActive: Bool) {
        layer.borderWidth = isActive ? 2 : 1
        layer.borderColor = isActive ? AppColor.guRed.cgColor : AppColor.ds_rtp.cgColor
        backgroundColor = isActive ? AppColor.guRed.withAlphaComponent(0.1) : AppColor.guBg
        pickIcon.image = isActive ? R.image.icon_ds_tick_ac() :  R.image.icon_ds_tick_un()
    }
}

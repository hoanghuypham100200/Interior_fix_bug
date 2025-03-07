import Foundation
import SnapKit
import UIKit

class ButtonDSV1: UIView {
    private lazy var tickImageView = UIImageView()
    private lazy var nameProductLabel = UILabel()
    private lazy var priceProductLabel = UILabel()
    private lazy var centerView = UIView()
    private lazy var pricePerweekLabel = UILabel()
    public lazy var button = UIButton()
   

    let dsViewModel = DirectStoreViewModel.shared
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        
        backgroundColor = AppColor.bg_1
        layer.cornerRadius = 20
        
        tickImageView.contentMode = .scaleAspectFit
        
        nameProductLabel.textColor = AppColor.yellow_dark
        nameProductLabel.font = .systemFont(ofSize: 18, weight: .regular)
        
        priceProductLabel.textColor = AppColor.yellow_dark
        priceProductLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        
        pricePerweekLabel.textColor = AppColor.yellow_dark
        pricePerweekLabel.font = .systemFont(ofSize: 18, weight: .regular)
        pricePerweekLabel.textAlignment = .right
        pricePerweekLabel.numberOfLines = 2
     
    }
    
    private func setupConstraints() {
       addSubview(tickImageView)
       addSubview(centerView)
       centerView.addSubview(priceProductLabel)
       centerView.addSubview(nameProductLabel)
       addSubview(pricePerweekLabel)
        addSubview(button)
        
        tickImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16.scaleX)
            $0.size.equalTo(CGSize(width: 20.scaleX, height: 20.scaleX))
        }
        
        centerView.snp.makeConstraints {
            $0.centerY.equalTo(tickImageView)
            $0.width.equalTo(200.scaleX)
            $0.leading.equalTo(tickImageView.snp.trailing).inset(-12.scaleX)
        }
        
        nameProductLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
        priceProductLabel.snp.makeConstraints {
            $0.top.equalTo(nameProductLabel.snp.bottom).inset(-4.scaleX)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        pricePerweekLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16.scaleX)
        }
        
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    public func updateYearly(yearlyPrice: String, weeklyTrialPrice: String, symbol: String) {
        let pricePerweek = dsViewModel.configPricePerWeek(price: yearlyPrice, divisor: 48) + symbol
        
        nameProductLabel.text = "YEARLY ACCESS"
        priceProductLabel.text = "Just \(yearlyPrice + symbol) per year"
        pricePerweekLabel.text = "\(pricePerweek) \nper week"
    }
    
    public func updateWeekTrial(weeklyTrialPrice: String, symbol: String) {
        nameProductLabel.text = "WEEKLY ACCESS"
        pricePerweekLabel.text = "\(weeklyTrialPrice + symbol ) \nper week"
    }
    
    func updateState(isActive: Bool) {
        layer.borderWidth = isActive ? 4 : 1
        layer.borderColor = isActive ? AppColor.yellow_normal_hover.cgColor : AppColor.bg_3.cgColor
        tickImageView.image = isActive ? R.image.icon_ds_tick_ac() :  R.image.icon_ds_tick_un()
    }
}

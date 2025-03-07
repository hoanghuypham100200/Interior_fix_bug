import SnapKit
import UIKit

class BestOfferView: UIView {
    
    private lazy var bestOfferLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        self.backgroundColor = AppColor.main
        self.cornerRadius = 10.scaleX
        self.clipsToBounds = true
        
        bestOfferLabel.setText(text: "Best Offer", color: AppColor.bg_1)
        bestOfferLabel.font = .systemFont(ofSize: 12, weight: .semibold)
    }
    
    private func setupConstraints() {
        addSubview(bestOfferLabel)
        
        bestOfferLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(7.scaleX)
            $0.top.bottom.equalToSuperview().inset(3.scaleX)
        }
    }
}


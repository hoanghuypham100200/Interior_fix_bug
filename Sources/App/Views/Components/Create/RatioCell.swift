import Foundation
import UIKit
import SnapKit
import Kingfisher

class RatioCell: BaseCollectionViewCell {
    private lazy var nameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstrains()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupViews() {
        contentView.backgroundColor = AppColor.light
        contentView.layer.cornerRadius = 18
        contentView.layer.borderColor = AppColor.bg_3.cgColor
        contentView.layer.borderWidth = 1
        contentView.clipsToBounds = true
        
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        nameLabel.textColor =  AppColor.yellow_dark
    }
    
    func setupConstrains() {
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func updateData(ratio: RatioConfigModel) {
        nameLabel.text = ratio.name
    }
    
    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? AppColor.yellow_dark : AppColor.light
            contentView.layer.borderWidth = isSelected ? 0 : 1
            nameLabel.textColor =  isSelected ? AppColor.bg_1 : AppColor.text_black
        }
    }
    
}

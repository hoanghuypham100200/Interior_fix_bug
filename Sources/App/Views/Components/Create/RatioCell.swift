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
        contentView.backgroundColor = AppColor.bg_ds
        contentView.layer.cornerRadius = 18
        contentView.clipsToBounds = true
        
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        nameLabel.textColor =  AppColor.text_black
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
            contentView.backgroundColor = isSelected ? AppColor.guRed : AppColor.bg_ds
            nameLabel.textColor =  isSelected ? AppColor.guBg : AppColor.text_black
        }
    }
    
}

import Foundation
import UIKit
import SnapKit
import Kingfisher

class RoomCell: BaseCollectionViewCell {
    private lazy var iconImageView = UIImageView()
    private lazy var nameLabel = UILabel()
    
    var roomType:RoomTypeModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstrains()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupViews() {
        backgroundColor = AppColor.bg_ds
        layer.cornerRadius = 18
        clipsToBounds = true
        
        iconImageView.contentMode = .scaleAspectFit
        
        nameLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        nameLabel.textColor =  AppColor.text_black
    }
    
    func setupConstrains() {
        addSubview(iconImageView)
        addSubview(nameLabel)
        
        iconImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(10.scaleX)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 20.scaleX, height: 19.scaleX))
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(iconImageView.snp.trailing).inset(-5.scaleX)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(10.scaleX)
        }
    }
    
    func updateData(room: RoomTypeModel, isSelected: Bool) {
        nameLabel.text = room.title
        roomType = room
        updateIconImageView(room: room)
        updateView(isSelected: isSelected)
    }
    
    override var isSelected: Bool {
        didSet {
           updateView(isSelected: isSelected)
        }
    }
    
    func updateView(isSelected: Bool) {
        backgroundColor = isSelected ? AppColor.guRed : AppColor.bg_ds
        guard let room = roomType else { return }
        nameLabel.textColor =  isSelected ? AppColor.guBg : AppColor.text_black
        iconImageView.setIconSystem(name: room.icon, color: isSelected ? AppColor.guBg :AppColor.text_black, weight: .regular, sizeIcon: 14)
    }
    
    func updateIconImageView(room: RoomTypeModel) {
        let icon_width = iconImageView.calculateWidth(for: room.icon, pointSize: 16, weight: .regular, targetHeight: 19)
        iconImageView.snp.updateConstraints {
            $0.leading.equalToSuperview().inset(10.scaleX)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: icon_width ?? 23.scaleX, height: 19.scaleX))
        }
    }
    
    
    
}

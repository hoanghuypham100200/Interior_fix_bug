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
        backgroundColor = AppColor.light
        layer.cornerRadius = 18
        layer.borderColor = AppColor.light_action.cgColor
        layer.borderWidth = 1
        clipsToBounds = true
        
        iconImageView.contentMode = .scaleAspectFit
        
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        nameLabel.textColor =  AppColor.yellow_dark
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
        backgroundColor = isSelected ? AppColor.yellow_dark : AppColor.light
        layer.borderWidth = isSelected ? 0 : 1
        guard let room = roomType else { return }
        nameLabel.textColor =  isSelected ? AppColor.light : AppColor.yellow_dark
        iconImageView.setIconSystem(name: room.icon, color: isSelected ? AppColor.light :AppColor.yellow_dark, weight: .regular)
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

import Foundation
import SnapKit
import UIKit

class LogoCell: UICollectionViewCell {

    public lazy var iconApp = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        contentView.layer.borderWidth = 2.scaleX
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.cornerRadius = 15.scaleX
        contentView.clipsToBounds = true
      
        iconApp.contentMode = .scaleAspectFit
        iconApp.clipsToBounds = true
        iconApp.cornerRadius =  15.scaleX
    }
    
    private func setupConstraints() {
        contentView.addSubview(iconApp)
        
        iconApp.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    public func update(avatar: String) {
        iconApp.image = UIImage(named: avatar)
    }
    
    override var isSelected: Bool {
        didSet {
            contentView.layer.borderColor = isSelected ? AppColor.text_black.cgColor : UIColor.clear.cgColor
            iconApp.cornerRadius = isSelected ? 10.scaleX : 15.scaleX
            iconApp.snp.updateConstraints {
                $0.edges.equalToSuperview().inset(isSelected ? 5.scaleX : 0)
            }
            UIView.animate(withDuration: 0.2) {
                self.layoutIfNeeded()
            }
        }
    }
}

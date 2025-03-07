import Foundation
import UIKit
import SnapKit
import Kingfisher

class StyleModalCell: UICollectionViewCell {
    private lazy var styleThumbView = UIView()
    private lazy var styleThumbImageView = UIImageView()
    private lazy var iconPremium = UIImageView()
    public lazy var styleNameLabel = UILabel()
    
    let userDefault = UserDefaultService.shared
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstrains()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        styleThumbImageView.kf.cancelDownloadTask()
        styleThumbImageView.image = nil
    }
    
    func setupViews() {
        styleThumbView.layer.cornerRadius = 20.scaleX
        styleThumbView.layer.borderColor = AppColor.yellow_normal_hover.cgColor
        styleThumbView.clipsToBounds = true
        
        styleThumbImageView.clipsToBounds = true
        styleThumbImageView.contentMode = .scaleAspectFill
        styleThumbImageView.layer.cornerRadius = 16.scaleX
        
        iconPremium.image = R.image.img_premium_lock()
        iconPremium.contentMode = .scaleAspectFit
        
        styleNameLabel.textColor = AppColor.text_black_patriona
        styleNameLabel.font = .systemFont(ofSize: 14, weight: .semibold)
    }
    
    func setupConstrains() {
        addSubview(styleThumbView)
        styleThumbView.addSubview(styleThumbImageView)
        styleThumbView.addSubview(iconPremium)
        addSubview(styleNameLabel)
        
        styleThumbView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(9.scaleX)
            $0.top.equalToSuperview()
            $0.height.equalTo(120.scaleX)
        }
        
        iconPremium.snp.makeConstraints {
            $0.trailing.equalTo(styleThumbImageView.snp.trailing).inset(15.scaleX)
            $0.top.equalTo(styleThumbImageView.snp.top).inset(15.scaleX)
            $0.size.equalTo(CGSize(width: 28.scaleX, height: 28.scaleX))
        }
    
        styleThumbImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        styleNameLabel.snp.makeConstraints {
            $0.top.equalTo(styleThumbView.snp.bottom).inset(-6.scaleX)
            $0.centerX.equalToSuperview()
        }
        
        
    }
    
    func setData(style: StyleConfigModel) {
        styleThumbImageView.loadImageKF(thumbURL: style.thumbUrl) { _ in}
        styleNameLabel.text = style.name
        guard !style.isPremium || userDefault.isPurchase else {
            return
        }
        
        iconPremium.isHidden = true
    }
}



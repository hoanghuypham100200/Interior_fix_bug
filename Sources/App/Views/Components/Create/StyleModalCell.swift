import Foundation
import UIKit
import SnapKit
import Kingfisher

class StyleModalCell: UICollectionViewCell {
    private lazy var styleThumbView = UIView()
    private lazy var styleThumbImageView = UIImageView()
    private lazy var iconPremium = UIImageView()
    public lazy var styleNameLabel = UILabel()
    public lazy var linearView = UIView()

    let userDefault = UserDefaultService.shared
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstrains()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        linearView.layer.sublayers?.forEach { layer in
            if layer is CAGradientLayer {
                layer.removeFromSuperlayer() // Hoặc có thể sử dụng layer.isHidden = true nếu bạn chỉ muốn ẩn gradient mà không xóa nó.
            }
        }
        
        linearView.setupGradient(colors: [AppColor.text_black.withAlphaComponent(0).cgColor, AppColor.text_black.withAlphaComponent(0.7).cgColor,AppColor.text_black.withAlphaComponent(0.9).cgColor], locations: [0, 0.5, 1.0], start: CGPoint(x: 0.5, y: 0), end: CGPoint(x: 0.5, y: 1.0))
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
        styleThumbView.layer.cornerRadius = 9.scaleX
        styleThumbView.layer.borderColor = AppColor.guRed.cgColor
        styleThumbView.clipsToBounds = true
        
        styleThumbImageView.clipsToBounds = true
        styleThumbImageView.contentMode = .scaleAspectFill
        styleThumbImageView.layer.cornerRadius = 5.scaleX
        
        iconPremium.image = R.image.img_premium_lock()
        iconPremium.contentMode = .scaleAspectFit
        
        styleNameLabel.textColor = AppColor.guBg
        styleNameLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        styleNameLabel.textAlignment = .center
    }
    
    func setupConstrains() {
        addSubview(styleThumbView)
        styleThumbView.addSubview(styleThumbImageView)
        styleThumbView.addSubview(iconPremium)
        styleThumbView.addSubview(linearView)
        linearView.addSubview(styleNameLabel)
        
        styleThumbView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalTo(83.scaleX)
        }
        
        iconPremium.snp.makeConstraints {
            $0.trailing.equalTo(styleThumbView.snp.trailing).inset(9.scaleX)
            $0.top.equalTo(styleThumbView.snp.top).inset(9.scaleX)
            $0.size.equalTo(CGSize(width: 26.scaleX, height: 26.scaleX))
        }
    
        linearView.snp.makeConstraints {
            $0.bottom.trailing.leading.equalToSuperview()
            $0.height.equalTo(20.scaleX)
        }
        
        styleThumbImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        styleNameLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(83.scaleX)
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



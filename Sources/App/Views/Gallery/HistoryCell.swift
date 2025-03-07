import Foundation
import RxSwift
import UIKit
import SnapKit

class HistoryCell: UICollectionViewCell {
    public lazy var galleryImageView = UIImageView()
    public lazy var iconTickImage = UIImageView()
//    public lazy var bottomView = UIView()
//    public lazy var titleLabel = UILabel()
    private let filesManager = FilesManager.shared
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstrains()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
//        layer.cornerRadius = 15.scaleX
        clipsToBounds = true
        layer.borderWidth = 1
        layer.borderColor = AppColor.guLine2.cgColor
        
        galleryImageView.contentMode = .scaleAspectFill
        galleryImageView.clipsToBounds = true
        
        iconTickImage.image = R.image.icon_gallery_un()
        iconTickImage.isHidden = true
//        titleLabel.font = .systemFont(ofSize: 12, weight: .regular)
//        titleLabel.textColor = AppColor.bg_1
//        titleLabel.numberOfLines = 2
//        titleLabel.textAlignment = .center
//
//        bottomView.clipsToBounds = true
//        bottomView.backgroundColor = AppColor.text_black.withAlphaComponent(0.75)
        
    }
    
    private func setupConstrains() {
        addSubview(galleryImageView)
        addSubview(iconTickImage)
//        addSubview(bottomView)
//        bottomView.addSubview(titleLabel)
        
        galleryImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        iconTickImage.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 22.scaleX, height: 22.scaleX))
            $0.bottom.trailing.equalToSuperview().inset(10.scaleX)
        }
        
//        bottomView.snp.makeConstraints {
//            $0.bottom.equalToSuperview()
//            $0.leading.trailing.equalToSuperview()
//            $0.height.equalTo(40.scaleX)
//        }
//
//        titleLabel.snp.makeConstraints {
//            $0.centerY.equalToSuperview()
//            $0.leading.trailing.equalToSuperview().inset(10.scaleX)
//        }
    }
    
    public func updateIconTick (value: Bool) {
        iconTickImage.isHidden = value

    }
    

    
    public func update(artWorkModel: ArtworkModel) {
        galleryImageView.loadImageKF(thumbURL: artWorkModel.url) { _ in }
//        titleLabel.text = "\(artWorkModel.room) - \(artWorkModel.style)"
    }
}


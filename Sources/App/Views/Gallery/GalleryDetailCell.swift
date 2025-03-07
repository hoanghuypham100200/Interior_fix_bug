

import Foundation
import RxSwift
import UIKit
import SnapKit

class GalleryDetailCell: BaseCollectionViewCell {
    private lazy var scrollView = UIScrollView()
    private lazy var contentScrollView = UIView()
    
    private lazy var frameThumbView = UIView()
    private lazy var resultImageView = UIImageView()
    private lazy var oldImageView = UIImageView()
    private lazy var showOldImageButton  = UIButton()
//    private lazy var descriptionResultView = DescriptionResultView()
    private let filesManager = FilesManager.shared
    
    var artwork: ArtworkModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstrains()
        setupRx()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resultImageView.kf.cancelDownloadTask()
        resultImageView.image = nil
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.clipsToBounds = true
        
        resultImageView.layer.cornerRadius = 15
        resultImageView.clipsToBounds = true

        
        frameThumbView.layer.cornerRadius = 15
        frameThumbView.clipsToBounds = true
        frameThumbView.layer.borderColor = AppColor.guLine2.cgColor
        frameThumbView.layer.borderWidth = 1

        oldImageView.alpha = 0
        oldImageView.layer.cornerRadius = 15
        oldImageView.clipsToBounds = true

        
        showOldImageButton.setImage(UIImage(systemName: "square.split.2x1",withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)), for: .normal)
        showOldImageButton.tintColor = AppColor.guBg
        showOldImageButton.layer.cornerRadius = 20
        showOldImageButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        
    }
    
    private func setupConstrains() {
        contentView.addSubview(scrollView)
        scrollView.addSubview(contentScrollView)
        contentScrollView.addSubview(frameThumbView)
        frameThumbView.addSubview(resultImageView)
        frameThumbView.addSubview(oldImageView)
//        frameThumbView.addSubview(iconButton)
        contentView.addSubview(showOldImageButton)
        
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentScrollView.snp.makeConstraints {
            $0.edges.width.equalToSuperview()
        }
        
        frameThumbView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
            $0.size.equalTo(CGSize(width: 344.scaleX, height: 344.scaleX))
        }
        
        resultImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        oldImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        showOldImageButton.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 40, height: 40))
            $0.bottom.equalTo(frameThumbView.snp.bottom).inset(20)
            $0.trailing.equalTo(frameThumbView.snp.trailing).inset(20)

        }
        
//        descriptionResultView.snp.makeConstraints {
//            $0.top.equalTo(resultImageView.snp.bottom).inset(-16.scaleX)
//            $0.leading.trailing.equalToSuperview().inset(16.scaleX)
//            $0.bottom.equalToSuperview().inset(50.scaleX)
//        }
    }
    
    private func setupRx() {
        let longPressGesture = UILongPressGestureRecognizer()
        showOldImageButton.addGestureRecognizer(longPressGesture)
        
        longPressGesture.rx.event
            .subscribe(onNext: { [weak self] gesture  in
                guard let owner = self,
                      let artwork = owner.artwork else { return }
                
                switch gesture.state {
                case .began:
                    owner.updateStateShowImage(showImageResult: false)
                case .ended:
                    owner.updateStateShowImage(showImageResult: true)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
    
    func updateStateShowImage(showImageResult: Bool) {
        
        guard let artwork = self.artwork else { return }
        oldImageView.image = filesManager.getImageFromDocumentDirectory(id: artwork.id)
        animeImage(alpha: showImageResult ? 0 : 1 )
    }
    
    public func update(artwork : ArtworkModel) {
        self.artwork = artwork
//        descriptionResultView.updateData(artwork: artwork)
        resultImageView.loadImageKF(thumbURL: artwork.url) { _ in}
        oldImageView.image = filesManager.getImageFromDocumentDirectory(id: artwork.id)
        
    }
    
    func animeImage(alpha: CGFloat) {
        UIView.animate(withDuration: 0.3) {
            self.oldImageView.alpha = alpha
        }
    }
}


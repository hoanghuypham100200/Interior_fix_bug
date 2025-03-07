

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
    private lazy var descriptionResultView = DescriptionResultView()
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
        
        resultImageView.contentMode = .scaleAspectFit
        resultImageView.clipsToBounds = true
        
        oldImageView.contentMode = .scaleAspectFit
        oldImageView.clipsToBounds = true
        oldImageView.alpha = 0
        
        frameThumbView.clipsToBounds = true
        frameThumbView.layer.borderColor = AppColor.bg_gray_button.cgColor
        frameThumbView.layer.borderWidth = 1
        
    }
    
    private func setupConstrains() {
        contentView.addSubview(scrollView)
        scrollView.addSubview(contentScrollView)
        contentScrollView.addSubview(frameThumbView)
        frameThumbView.addSubview(resultImageView)
        frameThumbView.addSubview(oldImageView)
        contentScrollView.addSubview(descriptionResultView)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentScrollView.snp.makeConstraints {
            $0.edges.width.equalToSuperview()
        }
        
        frameThumbView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(-1)
            $0.top.equalToSuperview()
            $0.height.equalTo(330.scaleX)
        }
        
        resultImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        oldImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        descriptionResultView.snp.makeConstraints {
            $0.top.equalTo(resultImageView.snp.bottom).inset(-16.scaleX)
            $0.leading.trailing.equalToSuperview().inset(16.scaleX)
            $0.bottom.equalToSuperview().inset(50.scaleX)
        }
    }
    
    private func setupRx() {
        let longPressGesture = UILongPressGestureRecognizer()
        descriptionResultView.changeThumbButton.addGestureRecognizer(longPressGesture)
        
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
        descriptionResultView.updateData(artwork: artwork)
        resultImageView.loadImageKF(thumbURL: artwork.url) { _ in}
        oldImageView.image = filesManager.getImageFromDocumentDirectory(id: artwork.id)
        
    }
    
    func animeImage(alpha: CGFloat) {
        UIView.animate(withDuration: 0.3) {
            self.oldImageView.alpha = alpha
        }
    }
}


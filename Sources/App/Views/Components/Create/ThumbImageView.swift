

import Foundation
import SnapKit
import UIKit

class ThumbImageView: UIView {
    public lazy var containerView = UIView()
    public lazy var imageCollectionView = UICollectionView()
    public lazy var uploadButton = UIButton()
    public lazy var pageControl = UIPageControl()
    public lazy var editButton = UIButton()

    public lazy var upImageView = UIImageView()
    public var editAction: (()->Void)!
    var thumbImageArray: [ArtworkModel] = []
    var indexCell = Int()



    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 344.scaleX, height: 344.scaleX)
        imageCollectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        imageCollectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
        imageCollectionView.setupCollectionView()
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.isPagingEnabled = true
        imageCollectionView.layer.borderWidth = 1
        imageCollectionView.layer.borderColor = AppColor.guLine2.cgColor
        imageCollectionView.layer.cornerRadius = 15

        
        uploadButton.setImage(R.image.bg_image_retouch(), for: .normal)
        uploadButton.clipsToBounds = true
        uploadButton.layer.cornerRadius = 20
        uploadButton.layer.borderWidth = 1
        uploadButton.layer.borderColor = AppColor.guRed.cgColor
        

        upImageView.contentMode = .scaleAspectFit
        upImageView.layer.cornerRadius = 15
        upImageView.clipsToBounds = true

        pageControl.backgroundColor = .lightGray
        pageControl.numberOfPages = thumbImageArray.count
        pageControl.pageIndicatorTintColor = AppColor.ds_rtp
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.layer.cornerRadius = 12
        
        editButton.setImage(UIImage(systemName: "pencil.line"), for: .normal)
        editButton.tintColor = .white
        editButton.backgroundColor = .black.withAlphaComponent(0.5)
        editButton.layer.cornerRadius = 20
    
    }
  
    
    private func setupConstraints() {
        addSubview(containerView)
        containerView.addSubview(imageCollectionView)
        containerView.addSubview(upImageView)
        containerView.addSubview(uploadButton)
        imageCollectionView.addSubview(pageControl)
        imageCollectionView.addSubview(editButton)
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        imageCollectionView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(344.scaleX)
            $0.leading.trailing.equalToSuperview()
        }
        upImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(344.scaleX)
            $0.centerX.equalToSuperview()
        }
        
        uploadButton.snp.makeConstraints {
            $0.bottom.leading.equalToSuperview().inset(20)
            $0.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        pageControl.snp.makeConstraints {
            $0.bottom.equalTo(containerView.snp.bottom).inset(18.scaleX)
            $0.centerX.equalTo(containerView)
            $0.height.equalTo(24.scaleX)
            $0.width.equalTo(Developer.isHasNortch ? 24.scaleX : 40.scaleX)
        }
        
        editButton.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 40, height: 40))
            $0.trailing.equalTo(containerView.snp.trailing).inset(20)
            $0.top.equalTo(containerView.snp.top).inset(20)
        }
    }
    
    func updatePageControl() {
        
        let imageCount = min(thumbImageArray.count,4)
        let widthPageControl  = imageCount * 20
        
        pageControl.snp.updateConstraints {
            $0.bottom.equalTo(containerView.snp.bottom).inset(18.scaleX)
            $0.centerX.equalTo(containerView)
            $0.height.equalTo(24.scaleX)
            $0.width.equalTo((20 + widthPageControl).scaleX)
        }
    }
    
    func scrollLastCell() {
        let lastItemIndex = thumbImageArray.count - 1
        print(lastItemIndex)
        if lastItemIndex >= 0 {
            imageCollectionView.reloadData()

            let indexPath = IndexPath(item: lastItemIndex, section: 0)
            imageCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    

}

extension ThumbImageView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return thumbImageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as? ImageCell else { return .init() }
        

        
        cell.update(artWorkModel: thumbImageArray[indexPath.row])
        return cell
    }
    
    @objc func didTapEdit() {
        editAction?()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let center = imageCollectionView.center
        let centerPoint = CGPoint(x: center.x + scrollView.contentOffset.x, y: center.y + scrollView.contentOffset.y)

        if let indexPath = imageCollectionView.indexPathForItem(at: centerPoint)
        {
            pageControl.currentPage = indexPath.item
            indexCell = indexPath.item
        }
    }
    

}

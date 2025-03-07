
import Foundation
import SnapKit
import UIKit
import Kingfisher
import Toast_Swift

class GalleryDetailViewController: BaseViewController {

    private lazy var artworkCollectionView = UICollectionView()
    private lazy var listButtonOfResultView = ListButtonOfResultView()
    
    let layout = UICollectionViewFlowLayout()
    
    private lazy var centerImageView = UIImageView()
        
    private let viewModel: HistoryViewModel = .init()
    private let userDefault = UserDefaultService.shared
    private let interstitialAdService: InterstitialAdService = .shared
    
    var isFisrtLoad = true
    var isFirstDidlayout = true
    var isLogoMode = true
    var indexCell = Int()
}

extension GalleryDetailViewController: UIActionSheetDelegate {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Check show intersitial ad
        displayIntersitialAd()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.async {
            // set height của item size bằng height collectio
            self.layout.itemSize = CGSize(width: self.view.bounds.width, height: self.artworkCollectionView.contentSize.height)
            
            guard self.isFirstDidlayout else { return }
            self.isFirstDidlayout = false
            let index = self.indexCell
            self.artworkCollectionView.isPagingEnabled = false
            self.artworkCollectionView.scrollToItem(
                at: IndexPath(item: index, section: 0),
                at: .centeredHorizontally,
                animated: false
            )
            self.artworkCollectionView.isPagingEnabled = true
        }
    }
    
    override func setupViews() {
        super.setupViews()
        // MARK: Setup views
        screenHeader.update(title: "Results")
        
        addScreenHeader()
        
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        artworkCollectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        artworkCollectionView.register(GalleryDetailCell.self, forCellWithReuseIdentifier: GalleryDetailCell.identifier)
        artworkCollectionView.dataSource = self
        artworkCollectionView.delegate = self
        artworkCollectionView.setupCollectionView()
        
        // MARK: Setup constrains
        view.addSubview(artworkCollectionView)
        view.addSubview(listButtonOfResultView)
        addDeletePopupView()
        
        artworkCollectionView.snp.makeConstraints {
            $0.top.equalTo(screenHeader.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(listButtonOfResultView.snp.top)
        }
        
        listButtonOfResultView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16.scaleX)
            $0.bottom.equalTo(view.snp_bottomMargin).inset(30.scaleX)
            $0.height.equalTo(65.scaleX)
        }
     
    }
    
    func deleteArtWork() {
        let index = indexCell
        let artworks = viewModel.artWorksValue
        
        configIndexCell()
        viewModel.deleteArtWork(artWorkModel: artworks[index])
        
        guard viewModel.artWorksValue.isEmpty  else { return }
        navigationController?.popViewController(animated: true)
    }
    
    private func configIndexCell() {
        guard !viewModel.artWorksValue.isEmpty else { return }
        let indexValue = indexCell
        
        if indexValue == 0 {
            indexCell = 0
        } else {
            indexCell = indexValue - 1
        }
    }
    
    func getImageFromCache(urlImage: String, completion: @escaping ((UIImage) -> ())) {
        let url = URL(string: urlImage)
        guard let url = url else { return }

        centerImageView.kf.setImage(with: url, options: [
            .progressiveJPEG(.init()),
            .callbackQueue(.mainAsync),
            .diskCacheExpiration(.never),
            .scaleFactor(UIScreen.main.scale)]) { [weak self] result in
            guard let wSelf = self else { return }
            switch result {
            case .success(let value):
                print("\(value)")
                guard let imageToUse = wSelf.centerImageView.image else { return }
                completion(imageToUse)
            case .failure(let error):
                wSelf.popupError()
                print("Kingfisher load failed \(error.localizedDescription)")
            }
        }
    }
    
    override func setupRx() {
        super.setupRx()
        
        actionBackScreenHeader()
        configTapDeletePopup()
        
        deletePopupView.sureButton.rx.tap
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: {owner, indexPath in
                owner.hideDeletePopup()
                owner.deleteArtWork()
            })
            .disposed(by: disposeBag)
        
        listButtonOfResultView.deleteButton.rx.tap
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: {owner, indexPath in
                owner.showDeletePopup()
            })
            .disposed(by: disposeBag)
        
        listButtonOfResultView.saveButton.rx.tap
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: {owner, indexPath in
                owner.convertImageSaveOrShare(mode: 0)
            })
            .disposed(by: disposeBag)
        
        listButtonOfResultView.shareButton.rx.tap
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: {owner, indexPath in
                owner.convertImageSaveOrShare(mode: 1)
            })
            .disposed(by: disposeBag)
        
        viewModel.artWorks
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: { owner, _ in
                owner.artworkCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
    }
    
    
    func convertImageSaveOrShare(mode: Int) {
      // mode 0 save, 1 share
        let urlThumb = viewModel.artWorksValue[indexCell].url
        
        centerImageView.loadImageKF(thumbURL: urlThumb) { [weak self] result in
            guard let wSelf = self else { return }
            guard  let mainImage = wSelf.centerImageView.image else {
                return
            }
            wSelf.saveOrShare(image: mainImage, mode: mode)
        }
    }
    
    func saveOrShare(image: UIImage, mode: Int) {
        switch mode {
        case 0:
            saveImage(imageResult: image)
        case 1:
            shareImage(imageResult: image)
        default: break
        }
    }
}

extension GalleryDetailViewController: UICollectionViewDataSource, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  viewModel.artWorksValue.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryDetailCell.identifier, for: indexPath) as? GalleryDetailCell
        else { return .init() }
        
        let artworkModel = viewModel.artWorksValue[indexPath.row]
        cell.update(artwork: artworkModel)
        
        return cell
    }
    
    // get correct index collection when scroll
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        visibleRect.origin = artworkCollectionView.contentOffset
        visibleRect.size = artworkCollectionView.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        guard let indexPath = artworkCollectionView.indexPathForItem(at: visiblePoint) else {
            return
        }
        indexCell = indexPath.row
    }
}

extension GalleryDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}


import Foundation
import UIKit
import SnapKit

protocol GalleryViewControllerDelegate: AnyObject {
    func didDeleteImage(artworkDeleteArray: [ArtworkModel])
}

class GalleryViewController: BaseViewController {
    weak var delegate: GalleryViewControllerDelegate?

    private lazy var empyView = EmptyView()
    private lazy var galleryCollectionView = UICollectionView()
    
    private let viewModel: HistoryViewModel = .init()
    private let userDefault = UserDefaultService.shared
    let historyViewModel = HistoryViewModel.shared

    var isDeleteMode = false
    var itemCount = 0
    var isFisrtLoad = true
    var isLoading = false
    var isLogoMode = true
    var artworkDeleteArray: [ArtworkModel] = []

    
}

extension GalleryViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Check show intersitial ad
        displayIntersitialAd()
    }
    
    override func setupViews() {
        super.setupViews()
       
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (view.frame.width -  5)/2, height:  (view.frame.width - 5)/2)
        galleryCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        galleryCollectionView.register(HistoryCell.self, forCellWithReuseIdentifier: HistoryCell.identifier)
        galleryCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        galleryCollectionView.dataSource = self
        galleryCollectionView.delegate = self
        galleryCollectionView.setupCollectionView()
        
        addGalleryScreenHeader()
        
        view.addSubview(galleryCollectionView)
        view.addSubview(empyView)
        
        galleryCollectionView.snp.makeConstraints {
            $0.top.equalTo(gallerySrceenHeader.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.snp_bottomMargin)
        }
        
        empyView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(gallerySrceenHeader.snp.bottom)
            $0.bottom.equalTo(view.snp_bottomMargin)
        }
    }
    
    override func setupRx() {
        super.setupRx()
        
        // MARK: Header
        gallerySrceenHeader.update(title: "Gallery")
        actionBackGalleryScreenHeader()
        actionDeleteModeScreenHeader()
        actionDoneScreenHeader()
        actionDeleteScreenHeader()
        // deleteView
        addDeletePopupView()
        configTapDeletePopup()
        
        deletePopupView.rightButton.rx.tap
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: {owner, indexPath in
                owner.delegate?.didDeleteImage(artworkDeleteArray: self.artworkDeleteArray)
                owner.deleteImage()
                owner.hideDeletePopup()
               
            })
            .disposed(by: disposeBag)

        viewModel.artWorks
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: { owner, _ in
                
                let listArt = owner.viewModel.artWorksValue
                
                owner.empyView.isHidden = listArt.isEmpty ? false : true
            
                if listArt.count < 11 {
                    owner.itemCount = listArt.count
                } else {
                    owner.itemCount = 10
                }
                owner.galleryCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.purchaseObservable
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: { owner, value in
                guard owner.userDefault.isPurchase else { return }
                owner.tabbarHeader.checkPurchase(isPurchase: true)
            })
            .disposed(by: disposeBag)
    }
    
    func actionDoneScreenHeader() {
        gallerySrceenHeader.doneButton.rx.tap
            .throttle(.milliseconds(300), scheduler: scheduler.main)
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: { owner, _ in
                owner.gallerySrceenHeader.updateIsDeleteMode(isDeleteMode: false)
                self.openToggleDeleteMode()

            })
            .disposed(by: disposeBag)
    }
    
    func actionDeleteScreenHeader() {
        gallerySrceenHeader.deleteButton.rx.tap
            .throttle(.milliseconds(300), scheduler: scheduler.main)
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: { owner, _ in
                owner.showPopup(view: owner.deletePopupView)
            })
            .disposed(by: disposeBag)
    }
    
    func actionDeleteModeScreenHeader() {
        gallerySrceenHeader.deleteModeButton.rx.tap
            .throttle(.milliseconds(300), scheduler: scheduler.main)
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: { owner, _ in
                owner.gallerySrceenHeader.updateIsDeleteMode(isDeleteMode: true)
                self.openToggleDeleteMode()
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: func delete image
    func openToggleDeleteMode() {
        isDeleteMode.toggle()
        galleryCollectionView.reloadData()
        galleryCollectionView.allowsMultipleSelection.toggle()

    }
    func deleteImage() {
        
        for artwork in artworkDeleteArray {
            historyViewModel.deleteArtWork(artWorkModel: artwork)
        }
        self.gallerySrceenHeader.updateIsDeleteMode(isDeleteMode: false)
        isDeleteMode.toggle()
    }
    
}

extension GalleryViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HistoryCell.identifier, for: indexPath) as? HistoryCell
        else { return .init() }
        cell.update(artWorkModel: viewModel.artWorksValue[indexPath.row] )
        
        if (isDeleteMode == true) {
            cell.updateIconTick(value: !isDeleteMode)
        } else {
            cell.updateIconTick(value: !isDeleteMode)
            cell.iconTickImage.image = R.image.icon_gallery_un()
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == itemCount - 1 && !isLoading {
            guard itemCount != viewModel.artWorksValue.count else { return }
            loadMoreData()
        }
    }
    
    func loadMoreData() {
        guard !isLoading else { return }
        isLoading = true
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            // Download more data here
            DispatchQueue.main.async { [weak self] in
                guard let wSelf = self else { return }
                
                let listArtWorks = wSelf.viewModel.artWorksValue
                if (wSelf.itemCount + 10 < listArtWorks.count + 1) {
                    wSelf.itemCount += 10
                } else {
                    wSelf.itemCount += listArtWorks.count - wSelf.itemCount
                }
                wSelf.galleryCollectionView.reloadData()
            }
            
            self.isLoading = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if (isDeleteMode == false) {
            let galleryDetailVC = GalleryDetailViewController()
            galleryDetailVC.indexCell = indexPath.row
            navigationController?.pushViewController(galleryDetailVC, animated: true)
        }
        else {
            guard let cell = collectionView.cellForItem(at: indexPath) as? HistoryCell
            else { return }
            cell.iconTickImage.image = R.image.icon_gallery_ac()
            artworkDeleteArray.append(viewModel.artWorksValue[indexPath.row])

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? HistoryCell
        else { return }
        cell.iconTickImage.image = R.image.icon_gallery_un()

        artworkDeleteArray.removeAll { $0.id == viewModel.artWorksValue[indexPath.row].id }
        

    }
}


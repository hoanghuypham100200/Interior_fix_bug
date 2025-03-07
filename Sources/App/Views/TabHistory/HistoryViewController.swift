import Foundation
import UIKit
import SnapKit

class HistoryViewController: BaseViewController {
    
    private lazy var empyView = EmptyView()
    private lazy var galleryCollectionView = UICollectionView()
    
    private let viewModel: HistoryViewModel = .init()
    private let userDefault = UserDefaultService.shared

    var itemCount = 0
    var isFisrtLoad = true
    var isLoading = false
    var isLogoMode = true
}

extension HistoryViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Check show intersitial ad
        displayIntersitialAd()
    }
    
    override func setupViews() {
        super.setupViews()
       
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (view.frame.width -  46)/2, height:  (view.frame.width - 46)/2)
        galleryCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        galleryCollectionView.register(HistoryCell.self, forCellWithReuseIdentifier: HistoryCell.identifier)
        galleryCollectionView.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
        galleryCollectionView.dataSource = self
        galleryCollectionView.delegate = self
        galleryCollectionView.setupCollectionView()
        
        addTabbarHeader()
        view.addSubview(galleryCollectionView)
        view.addSubview(empyView)
        
        galleryCollectionView.snp.makeConstraints {
            $0.top.equalTo(tabbarHeader.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.snp_bottomMargin)
        }
        
        empyView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(tabbarHeader.snp.bottom)
            $0.bottom.equalTo(view.snp_bottomMargin)
        }
    }
    
    override func setupRx() {
        super.setupRx()
        
        // MARK: Header
        configTapPremiumTabbarHeader()
        
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
    
    
}

extension HistoryViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HistoryCell.identifier, for: indexPath) as? HistoryCell
        else { return .init() }
        cell.update(artWorkModel: viewModel.artWorksValue[indexPath.row] )
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
        let galleryDetailVC = GalleryDetailViewController()
        galleryDetailVC.indexCell = indexPath.row
        navigationController?.pushViewController(galleryDetailVC, animated: true)
    }
}

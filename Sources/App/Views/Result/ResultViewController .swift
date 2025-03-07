import Foundation
import NVActivityIndicatorView
import GrowingTextView
import SnapKit
import UIKit
import RxSwift

class ResultViewController: BaseViewController {
    private lazy var scrollView = UIScrollView()
    private lazy var contentScrollView = UIView()
    private lazy var frameThumbView = UIView()
    private lazy var oldImageView = UIImageView()
    private lazy var resultImageView = UIImageView()
    private lazy var descriptionResultView = DescriptionResultView()
    private lazy var listButtonOfResultView = ListButtonOfResultView()
    
    let viewModel: ResultViewModel = .init()
    let historyViewModel = HistoryViewModel.shared
    let userDefault = UserDefaultService.shared
    private let filesManager = FilesManager.shared
    var artwork: ArtworkModel?
}

extension ResultViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.updateDailyTime { _ in }
        displayIntersitialAd()
       
    }

    override func setupViews() {
        super.setupViews()
        
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
        
        screenHeader.update(title: "Results")
        
        addScreenHeader()
        view.addSubview(scrollView)
        scrollView.addSubview(contentScrollView)
        contentScrollView.addSubview(resultImageView)
        contentScrollView.addSubview(frameThumbView)
        frameThumbView.addSubview(resultImageView)
        frameThumbView.addSubview(oldImageView)
        contentScrollView.addSubview(descriptionResultView)
        view.addSubview(listButtonOfResultView)
        addDeletePopupView()
        addRatingView()
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(screenHeader.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(listButtonOfResultView.snp.top)
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
        
        listButtonOfResultView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16.scaleX)
            $0.bottom.equalTo(view.snp_bottomMargin).inset(30.scaleX)
            $0.height.equalTo(65.scaleX)
        }
        
       updateStateShowImage(showImageResult: true)
       configShowRatingCreate()
    }
    
    func updateData(artwork: ArtworkModel) {
        self.artwork = artwork
        descriptionResultView.updateData(artwork: artwork)
        resultImageView.loadImageKF(thumbURL: artwork.url) { _ in}
      
    }
    
    func updateStateShowImage(showImageResult: Bool) {
        
        guard let artwork = self.artwork else { return }
        oldImageView.image = filesManager.getImageFromDocumentDirectory(id: artwork.id)
        animeImage(alpha: showImageResult ? 0 : 1 )
    }
    
    func animeImage(alpha: CGFloat) {
        UIView.animate(withDuration: 0.3) {
            self.oldImageView.alpha = alpha
        }
    }
    
    func deleteImage() {
        guard let artwork = self.artwork else {
            return
        }
        historyViewModel.deleteArtWork(artWorkModel: artwork)
        navigationController?.popViewController(animated: true)
    }
        
    override func setupRx() {
        super.setupRx()
     
        actionBackScreenHeader()
        configTapDeletePopup()
        configTapRating()
        
        deletePopupView.sureButton.rx.tap
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: {owner, indexPath in
                owner.hideDeletePopup()
                owner.deleteImage()
            })
            .disposed(by: disposeBag)
        
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
                guard let image = owner.resultImageView.image else { return }
                owner.saveImage(imageResult: image )
            })
            .disposed(by: disposeBag)
        
        listButtonOfResultView.shareButton.rx.tap
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: {owner, indexPath in
                guard let image = owner.resultImageView.image else { return }
                owner.shareImage(imageResult: image )
            })
            .disposed(by: disposeBag)
        
    }
    
    func configShowRatingCreate() {
        guard viewModel.ratingConfigValue.call_api.enable else { return }
        guard !userDefault.ratingConfig.didShow else { return }
        let count = viewModel.ratingConfigValue.call_api.count
        
        guard userDefault.ratingConfig.count_create == count else {
            userDefault.ratingConfig.count_create += 1
            return
        }
        showRating()
        userDefault.ratingConfig.didShow = true
    }
    
}


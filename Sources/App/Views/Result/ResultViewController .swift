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
    private lazy var showOldImageButton  = UIButton()

    public var ExampleRetouchImage: String?

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
        //MARK: set up Views
        scrollView.showsVerticalScrollIndicator = false
        scrollView.clipsToBounds = true
        
        resultImageView.contentMode = .scaleAspectFill
        resultImageView.layer.cornerRadius = 15
        resultImageView.clipsToBounds = true
        
        frameThumbView.layer.borderWidth = 1
        frameThumbView.layer.borderColor = AppColor.guLine2.cgColor
        frameThumbView.layer.cornerRadius = 15
        frameThumbView.clipsToBounds = true
        
        oldImageView.contentMode = .scaleAspectFill
        oldImageView.clipsToBounds = true
        oldImageView.layer.cornerRadius = 15
        oldImageView.alpha = 0
        
        showOldImageButton.setImage(UIImage(systemName: "square.split.2x1", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)), for: .normal)
        showOldImageButton.tintColor = AppColor.guBg
        showOldImageButton.layer.cornerRadius = 20
        showOldImageButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
       
        
        screenHeader.update(title: "Results")
        
        
        //MARK: Constraints
        addScreenHeader()
        view.addSubview(scrollView)
        scrollView.addSubview(contentScrollView)
        contentScrollView.addSubview(resultImageView)
        contentScrollView.addSubview(frameThumbView)
        frameThumbView.addSubview(resultImageView)
        frameThumbView.addSubview(oldImageView)
        view.addSubview(showOldImageButton)
        view.addSubview(listButtonOfResultView)
        addSavePopupView()
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
        
        
        listButtonOfResultView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16.scaleX)
            $0.bottom.equalTo(view.snp_bottomMargin).inset(13.scaleX)
            $0.height.equalTo(65.scaleX)
        }
    }
    
    //MARK: RX
    override func setupRx() {
        super.setupRx()
     
        actionBackScreenHeader()
        configTapRating()
        configTapSavePopup()
        updateStateShowImage(showImageResult: true)
        configShowRatingCreate()
        configTapSavePopup()
        
        savePopupView.rightButton.rx.tap
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: {owner, indexPath in
                owner.hideDeletePopup()
                guard let image = owner.resultImageView.image else { return }
                owner.saveImage(imageResult: image )
            })
            .disposed(by: disposeBag)
        
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
        
        listButtonOfResultView.saveButton.rx.tap
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: {owner, indexPath in

                owner.showPopup(view: owner.savePopupView)

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
    //MARK: func
    func updateData(artwork: ArtworkModel) {
        self.artwork = artwork
        resultImageView.loadImageKF(thumbURL: artwork.url) { _ in}
      
    }
    
    func updateImage(exampleRetouchModel: ExampleRetouchModel) {
        resultImageView.loadImageKF(thumbURL: exampleRetouchModel.thumbEdit) { _ in}
        oldImageView.loadImageKF(thumbURL: exampleRetouchModel.thumbUrl) { _ in}

    }
    
    func updateStateShowImage(showImageResult: Bool) {
        
        guard let artwork = self.artwork else { return }
        if (artwork.id.isEmpty) {
            oldImageView.loadImageKF(thumbURL: ExampleRetouchImage ?? "") { _ in}
            animeImage(alpha: showImageResult ? 0 : 1 )
        } else {
            oldImageView.image = filesManager.getImageFromDocumentDirectory(id: artwork.id)
            animeImage(alpha: showImageResult ? 0 : 1 )
        }

    }
    
    func animeImage(alpha: CGFloat) {
        UIView.animate(withDuration: 0.3) {
            self.oldImageView.alpha = alpha
        }
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


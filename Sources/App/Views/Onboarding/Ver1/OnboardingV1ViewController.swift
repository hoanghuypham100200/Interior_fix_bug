import SnapKit
import UIKit
import SnapKit

class OnboardingV1ViewController: BaseViewController {
    private lazy var obCollectionView = UICollectionView()
    private lazy var linearView = UIView()
    private lazy var titleLabel = UILabel()
    private lazy var descriptionLabel = UILabel()
    private lazy var titleCell0View = UIView()
    private lazy var titleCell0Label_1 = UILabel()
    private lazy var titleCell0Label_2 = UILabel()
    private lazy var bellIcon = UIImageView()
    private lazy var continueButton = UIButton()
    
    var currentPage = 1
    var obData: [OnboardingItem] = []
    let viewModel = OnboardingViewModel.init()
}

extension OnboardingV1ViewController {
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        linearView.layer.sublayers?.forEach { layer in
            if layer is CAGradientLayer {
                layer.removeFromSuperlayer() // Hoặc có thể sử dụng layer.isHidden = true nếu bạn chỉ muốn ẩn gradient mà không xóa nó.
            }
        }
        
        linearView.setupGradient(colors: [
            AppColor.line_ob.withAlphaComponent(0).cgColor,
            AppColor.line_ob.withAlphaComponent(0.97).cgColor,
            AppColor.line_ob.withAlphaComponent(0.97).cgColor],
                                 locations: [0, 0.24, 1.0],
                                 start: CGPoint(x: 1.0, y: 0.0),
                                 end: CGPoint(x: 1.0, y: 1.0))
    }
    
    override func setupViews() {
        super.setupViews()
        titleLabel.font =  UIFont.appFont(size: 28)
        titleLabel.textColor = AppColor.text_black_patriona
        
        titleCell0Label_1.font =  UIFont.appFont(size: 28)
        titleCell0Label_1.textColor = AppColor.text_black_patriona
        
        titleCell0Label_2.font =  UIFont.appFont(size: 28)
        titleCell0Label_2.textColor = AppColor.text_black_patriona
        
        descriptionLabel.font = .systemFont(ofSize: 18, weight: .medium)
        descriptionLabel.textColor = AppColor.yellow_dark
        
        // MARK: Setup views
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.bounds.width, height: view.bounds.height)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        obCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        obCollectionView.register(OnboardingV1Cell.self, forCellWithReuseIdentifier: OnboardingV1Cell.identifier)
        obCollectionView.isScrollEnabled = false
        obCollectionView.contentInsetAdjustmentBehavior = .never
        obCollectionView.setupCollectionView()
        obCollectionView.backgroundColor = .red
        
        bellIcon.setIcon(icon: RImage.ic_bell())
        
        continueButton.setupTitleButton(title: "CONTINUE", fontWeight: .semibold, fontSize: 16, titleColor: AppColor.guBg, bgColor: AppColor.red, radius: 20)
        continueButton.layer.borderWidth = 1.scaleX
        continueButton.layer.borderColor = AppColor.premium.cgColor
        
        view.addSubview(obCollectionView)
        view.addSubview(linearView)
        view.addSubview(titleLabel)
        view.addSubview(titleCell0View)
        titleCell0View.addSubview(titleCell0Label_1)
        titleCell0View.addSubview(titleCell0Label_2)
        view.addSubview(descriptionLabel)
        view.addSubview(bellIcon)
        view.addSubview(continueButton)
        
        obCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        linearView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.top).inset(-90.scaleX)
        }
        
        titleLabel.snp.makeConstraints {
            $0.bottom.equalTo(descriptionLabel.snp.top).inset(-8.scaleX)
            $0.height.equalTo(32.scaleX)
            $0.centerX.equalToSuperview()
        }
        
        titleCell0View.snp.makeConstraints {
            $0.bottom.equalTo(descriptionLabel.snp.top).inset(-8.scaleX)
            $0.height.equalTo(32.scaleX)
            $0.centerX.equalToSuperview()
        }
        
        titleCell0Label_1.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(titleCell0Label_2.snp.leading)
        }
        
        titleCell0Label_2.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.bottom.equalTo(bellIcon.snp.top).inset(-8.scaleX)
            $0.centerX.equalToSuperview()
        }
        
        bellIcon.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(continueButton.snp.top).inset(-35.scaleX)
            $0.size.equalTo(CGSize(width: 37.scaleX, height: 34.scaleX))
        }
        
        continueButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16.scaleX)
            $0.bottom.equalTo(view.snp_bottomMargin).inset(29.scaleX)
            $0.height.equalTo(54.scaleX)
        }
    }
    
    func openDS() {
        let dsVC = AppRouter.makeDirectStoreOnboarding()
        navigationController?.pushViewController(dsVC, animated: true)
    }
    
    func updateText(obItem: OnboardingItem, index: Int){
        descriptionLabel.text = obItem.description
        let isCell0 = index == 0
        titleCell0View.isHidden = !isCell0
        titleLabel.isHidden = isCell0
        if index == 0 {
            titleCell0Label_1.text = obItem.title
            titleCell0Label_2.text = "ith A.I."
        } else {
            titleLabel.text = obItem.title
        }
    }
    
    override func setupRx() {
        super.setupRx()
        
        continueButton.rx.tap
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: { owner, _ in
                
                switch owner.currentPage {
                case 1:
                    owner.currentPage = owner.currentPage + 1
                    owner.updateText(obItem: owner.obData[1], index: 1)
                    let indexPath = IndexPath(item: 1, section: 0)
                    owner.obCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                case 2:
                    owner.currentPage = owner.currentPage + 1
                    owner.updateText(obItem: owner.obData[2], index: 2)
                    let indexPath = IndexPath(item: 2, section: 0)
                    owner.obCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                case 3:
                    owner.openDS()
                    owner.removeLastScreen(isDirectStore: false)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.getOnboardingDataOsb(version: .onboardingV1)
            .do(onNext: { [weak self] value in
                guard let owner = self else { return }
                owner.obData = value
                owner.updateText(obItem: value[0], index: 0)
            })
            .bind(to: obCollectionView.rx.items(cellIdentifier: OnboardingV1Cell.identifier, cellType: OnboardingV1Cell.self)) { index, data, cell in
                cell.update(obModel: data)
            }
            .disposed(by: disposeBag)
    }
}

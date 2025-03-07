import Foundation
import UIKit
import SnapKit
import RxSwift
import Qonversion
import NVActivityIndicatorView

class DirectStoreV1ViewController: DirectStoreBaseViewController {
    private lazy var bgImageView = UIImageView()
    private lazy var closeButton = UIButton()
    
    private lazy var centerView = UIView()
    private lazy var titleLabel = UILabel()
    private lazy var commitDSView = CommitDSView()
    private lazy var weeklyButton = ButtonDSV1()
    private lazy var yearlyButton = ButtonDSV1()
    private lazy var bestOfferView = UIView()
    private lazy var titlebestOfferLabel = UILabel()
    
    private lazy var bottomView = UIButton()
    private lazy var continueButton = UIButton()
    private lazy var rtpView = RTPView()
    private lazy var perWeekLabel = UILabel()
    
    private let loading = NVActivityIndicatorView(frame: .zero, type: .circleStrokeSpin, color: AppColor.yellow_normal_hover, padding: 0)
    
    let viewModel = DirectStoreViewModel.init()
    let purchaseManager = PurchaseManagerImpl.shared
    let userDefault = UserDefaultService.shared
    let iapManager = IAPManager.shared
    var priceWeekly = ""
    var priceYearly = ""
    var symbol = ""
    
    var isPickYearly = false
}

extension DirectStoreV1ViewController {
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        centerView.layer.sublayers?.forEach { layer in
            if layer is CAGradientLayer {
                layer.removeFromSuperlayer() // Hoặc có thể sử dụng layer.isHidden = true nếu bạn chỉ muốn ẩn gradient mà không xóa nó.
            }
        }

        centerView.setupGradient(colors: [AppColor.line_ob.withAlphaComponent(0).cgColor, AppColor.line_ob.withAlphaComponent(0.97).cgColor,AppColor.line_ob.withAlphaComponent(0.97).cgColor], locations: [0, 0.27, 1.0], start: CGPoint(x: 0.5, y: 0), end: CGPoint(x: 0.5, y: 1.0))
        centerView.setupGradient(colors: [AppColor.bg_view_1.withAlphaComponent(0).cgColor, AppColor.bg_view_1.withAlphaComponent(0.97).cgColor,AppColor.bg_view_1.withAlphaComponent(0.97).cgColor], locations: [0, 0.27, 1.0], start: CGPoint(x: 0.5, y: 0), end: CGPoint(x: 0.5, y: 1.0))
    }
    
    override func setupViews() {
        super.setupViews()
        
        //MARK: SETUP VIEWS
        
        bgImageView.image = R.image.img_bg_ds()
        bgImageView.contentMode = .scaleAspectFill
        bgImageView.clipsToBounds = true
        
        closeButton.setImage(R.image.img_circle_close(), for: .normal)
        closeButton.imageView?.contentMode = .scaleAspectFit
      
        titleLabel.setText(text: "Unlock Premium Home", color: AppColor.text_black_patriona)
        titleLabel.font = UIFont.appFont(size: 32)
        
        perWeekLabel.setText(text: "then only 3.99$ per week", color: AppColor.text_black_patriona)
        perWeekLabel.font = .systemFont(ofSize: 16, weight: .regular)
        
        continueButton.setupContinueButton()
        
        bestOfferView.cornerRadius = 12
        
        bottomView.backgroundColor = AppColor.line_ob
        
        titlebestOfferLabel.textColor = AppColor.bg_1
        titlebestOfferLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        titlebestOfferLabel.text = "BEST OFFER"
        
        //MARK: SETUP CONSTRAINS
        
        view.addSubview(bgImageView)
        view.addSubview(closeButton)
        view.addSubview(centerView)
        view.addSubview(bottomView)
        
        centerView.addSubview(titleLabel)
        centerView.addSubview(commitDSView)
        centerView.addSubview(weeklyButton)
        centerView.addSubview(yearlyButton)
        centerView.addSubview(bestOfferView)
        bestOfferView.addSubview(titlebestOfferLabel)
        
        bottomView.addSubview(perWeekLabel)
        bottomView.addSubview(continueButton)
        bottomView.addSubview(rtpView)
        
        view.addSubview(loading)
        
        bgImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalTo(view.snp_topMargin).inset(13.scaleX)
            $0.leading.equalToSuperview().inset(16.scaleX)
            $0.size.equalTo(CGSize(width: 44.scaleX, height: 44.scaleX))
        }
        
        centerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(bottomView.snp.top)
            $0.height.equalTo(422.scaleX)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(commitDSView.snp.top).inset(-12.scaleX)
        }
        
        commitDSView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(weeklyButton.snp.top).inset(-20.scaleX)
            $0.size.equalTo(CGSize(width: 300.scaleX, height: 40.scaleX))
        }
        
        weeklyButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20.scaleX)
            $0.bottom.equalTo(yearlyButton.snp.top).inset(-18.scaleX)
            $0.height.equalTo(90.scaleX)
        }
        
        yearlyButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20.scaleX)
            $0.bottom.equalToSuperview().inset(15.scaleX)
            $0.height.equalTo(90.scaleX)
        }
        
        bestOfferView.snp.makeConstraints {
            $0.top.equalTo(yearlyButton.snp.top).inset(-12.scaleX)
            $0.size.equalTo(CGSize(width: 90.scaleX, height: 24.scaleX))
            $0.trailing.equalTo(yearlyButton.snp.trailing)
        }
        
        titlebestOfferLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        bottomView.snp.makeConstraints {
            $0.bottom.equalTo(view.snp_bottomMargin)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(145.scaleX)
        }
        
        perWeekLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(continueButton.snp.top).inset(-16.scaleX)
        }
        
        continueButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16.scaleX)
            $0.bottom.equalTo(rtpView.snp.top).inset(-16.scaleX)
            $0.height.equalTo(54.scaleX)
        }
        
        rtpView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(12.scaleX)
            $0.height.equalTo(16.scaleX)
            $0.centerX.equalToSuperview()
        }
        
        loading.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 50.scaleX, height: 50.scaleX))
            $0.center.equalToSuperview()
        }
        
        configInitView()
    }
    
    private func configInitView() {
        // show close button
        let dispatchAfter = DispatchTimeInterval.seconds(Int(userDefault.dsConfig.close_button_delay))
        DispatchQueue.main.asyncAfter(deadline: .now() + dispatchAfter) {
            self.closeButton.isHidden = false
        }
        
        loading.startAnimating()
        
        iapManager.disPlayProduct { [weak self] success in
            guard let wSelf = self else { return }
            if success {
                wSelf.loading.stopAnimating()
                let listProduct = wSelf.iapManager.listProducts
                var weeklyTrialPrice = ""
                
                print("---- qonversion: List product: \(listProduct)")
                
                if let index = listProduct.firstIndex(where: { $0.id == Developer.weeklyTrialID}) {
                    wSelf.weeklyButton.updateWeekTrial(weeklyTrialPrice: listProduct[index].price,
                                                            symbol: listProduct[index].symbol)
                    weeklyTrialPrice = listProduct[index].price
                    wSelf.priceWeekly = listProduct[index].price
                }
                
                if let index = listProduct.firstIndex(where: { $0.id == Developer.yearlyID}) {
                    wSelf.yearlyButton.updateYearly(yearlyPrice: listProduct[index].price,
                                                    weeklyTrialPrice: weeklyTrialPrice,
                                                    symbol: listProduct[index].symbol)
                    wSelf.priceYearly = listProduct[index].price
                    wSelf.symbol = listProduct[index].symbol
                }
                
                wSelf.updateStateButton(isYearly: wSelf.isPickYearly)
                
            } else {
                print("---- qonversion: Fail to load price")
                wSelf.closeDS()
            }
        }
        
        // Event ds_limit
        viewModel.trackLimit(value)
        
        // Even ds_onboarding / ds_launch
        guard isObLaunch else { return }
        viewModel.trackOborLaunch(event)
    }
    
    private func closeDS() {
        if userDefault.isFirstLaunch {
            removeLastScreen(isDirectStore: true)
        } else {
            dismiss(animated: true)
        }
    }
    
    private func updateStateButton(isYearly: Bool) {
        yearlyButton.updateState(isActive: isYearly)
        weeklyButton.updateState(isActive: !isYearly)
        bestOfferView.backgroundColor = isYearly ? AppColor.yellow_normal_hover : AppColor.yellow_dark
        updatePerWeek(isYearly: isYearly)
        isPickYearly = isYearly
    }
    
    func updatePerWeek(isYearly: Bool) {
        let pricePerweek = isYearly ? viewModel.configPricePerWeek(price: priceYearly, divisor: 48) + symbol : "\(priceWeekly + symbol)"
        
        let textTop = NSMutableAttributedString(string: "then only ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular), NSAttributedString.Key.foregroundColor: AppColor.text_black_patriona])
        let textCenter = NSMutableAttributedString(string: pricePerweek, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .semibold), NSAttributedString.Key.foregroundColor: AppColor.text_black_patriona])
        let textBottom = NSMutableAttributedString(string: " per week", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular), NSAttributedString.Key.foregroundColor: AppColor.text_black_patriona])
        
        textTop.append(textCenter)
        textTop.append(textBottom)
        perWeekLabel.attributedText = textTop
    }
    
   
    
    private func makePurchase(productID: String) {
        guard !iapManager.listProducts.isEmpty else { return }
        disableButton(isDisable: true)
        loading.startAnimating()
        iapManager.purchase(product: productID) { [weak self] success in
            guard let wSelf = self else { return }
            
            if success {
                wSelf.purchaseManager.updatePurchase(isPurchase: true)
                
                // event tracking
                wSelf.viewModel.trackLimitPurchased(wSelf.value, productID)
                // track thêm nếu từ ob hoặc launch
                if wSelf.isObLaunch {
                    wSelf.viewModel.trackObLaunchPuchased(wSelf.eventPurchased, productID)
                }
                
                wSelf.closeDS()
                wSelf.loading.stopAnimating()
                wSelf.disableButton(isDisable: false)
            } else {
                print("========> failed lifetime to buy")
                wSelf.loading.stopAnimating()
                wSelf.disableButton(isDisable: false)
            }
        }
    }
    
    func disableButton(isDisable: Bool) {
        yearlyButton.button.isUserInteractionEnabled = !isDisable
        weeklyButton.button.isUserInteractionEnabled = !isDisable
        continueButton.isUserInteractionEnabled = !isDisable
    }
    
    override func setupRx() {
        super.setupRx()
        
        closeButton.rx.tap
            .observe(on: scheduler.main)
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                // set is first launch
                if owner.userDefault.isFirstLaunch {
                    owner.closeDS()
                } else {
                    owner.dismiss(animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        yearlyButton.button.rx.tap
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: { owner, _ in
                owner.updateStateButton(isYearly: true)
            })
            .disposed(by: disposeBag)
        
        weeklyButton.button.rx.tap
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: { owner, _ in
                owner.updateStateButton(isYearly: false)
            })
            .disposed(by: disposeBag)
        
        continueButton.rx.tap
            .observe(on: scheduler.main)
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.makePurchase(productID: owner.isPickYearly ? Developer.yearlyID : Developer.weeklyTrialID)
            })
            .disposed(by: disposeBag)
        
        rtpView.restoreButton.rx.tap
            .observe(on: scheduler.main)
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.loading.startAnimating()
                owner.iapManager.restorePurchase { success in
                    if success {
                        owner.loading.stopAnimating()
                        owner.closeDS()
                        print("=======> restore ok")
                    }
                    else {
                        print("=======> restore failed")
                        owner.loading.stopAnimating()
                    }
                }
            })
            .disposed(by: disposeBag)
        
        rtpView.privacyButton.rx.tap
            .observe(on: scheduler.main)
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.openUrl(url: Developer.privacyPolicy)
            })
            .disposed(by: disposeBag)
        
        rtpView.termButton.rx.tap
            .observe(on: scheduler.main)
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.openUrl(url: Developer.termOfUse)
            })
            .disposed(by: disposeBag)
    }
}

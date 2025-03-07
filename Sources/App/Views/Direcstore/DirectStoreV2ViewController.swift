import Foundation
import UIKit
import SnapKit
import RxSwift
import Qonversion
import NVActivityIndicatorView

class DirectStoreV2ViewController: DirectStoreBaseViewController {
    private lazy var bgImageView = UIImageView()
    private lazy var closeButton = UIButton()
    private lazy var gradientView = UIView()
    private lazy var titleLabel = UILabel()
    private lazy var commitDSView = CommitDSView()
    private lazy var weeklyButton = ButtonDSV2()
    private lazy var yearlyButton = ButtonDSV2()
    private lazy var bestOfferView = UIView()
    private lazy var titlebestOfferLabel = UILabel()
    private lazy var descriptView = DescriptionDSView()
    private lazy var continueButton = UIButton()
    private lazy var rtpView = RTPView()
    
    private let loading = NVActivityIndicatorView(frame: .zero, type: .circleStrokeSpin, color: AppColor.yellow_normal_hover, padding: 0)
    
    let viewModel = DirectStoreViewModel.init()
    let purchaseManager = PurchaseManagerImpl.shared
    let userDefault = UserDefaultService.shared
    let iapManager = IAPManager.shared
    var isPickYearly = false
}

extension DirectStoreV2ViewController {
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientView.layer.sublayers?.forEach { layer in
            if layer is CAGradientLayer {
                layer.removeFromSuperlayer() // Hoặc có thể sử dụng layer.isHidden = true nếu bạn chỉ muốn ẩn gradient mà không xóa nó.
            }
        }
        
        gradientView.setupGradient(colors: [AppColor.line_ob.withAlphaComponent(0).cgColor, AppColor.line_ob.withAlphaComponent(0.97).cgColor,AppColor.line_ob.withAlphaComponent(0.97).cgColor], locations: [0, 0.27, 1.0], start: CGPoint(x: 0.5, y: 0), end: CGPoint(x: 0.5, y: 1.0))
        gradientView.setupGradient(colors: [AppColor.bg_view_1.withAlphaComponent(0).cgColor, AppColor.bg_view_1.withAlphaComponent(0.97).cgColor,AppColor.bg_view_1.withAlphaComponent(0.97).cgColor], locations: [0, 0.27, 1.0], start: CGPoint(x: 0.5, y: 0), end: CGPoint(x: 0.5, y: 1.0))
    }
    
    override func setupViews() {
        super.setupViews()
        //MARK: Setup views
        bgImageView.image = R.image.img_bg_ds()
        bgImageView.contentMode = .scaleAspectFill
        bgImageView.clipsToBounds = true
        
        closeButton.setImage(R.image.img_circle_close(), for: .normal)
        closeButton.imageView?.contentMode = .scaleAspectFit
        
        titleLabel.setText(text: "Unlock Premium Home", color: AppColor.text_black_patriona)
        titleLabel.font = UIFont.appFont(size: 32)
        
        continueButton.setupContinueButton()
        
        bestOfferView.cornerRadius = 12.scaleX
        
        titlebestOfferLabel.textColor = AppColor.bg_1
        titlebestOfferLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        titlebestOfferLabel.text = "BEST OFFER"
        
        //MARK: Setup constraints
        view.addSubview(bgImageView)
        view.addSubview(closeButton)
        view.addSubview(gradientView)
        gradientView.addSubview(titleLabel)
        gradientView.addSubview(commitDSView)
        gradientView.addSubview(weeklyButton)
        gradientView.addSubview(yearlyButton)
        gradientView.addSubview(bestOfferView)
        bestOfferView.addSubview(titlebestOfferLabel)
        view.addSubview(descriptView)
        view.addSubview(continueButton)
        view.addSubview(rtpView)
        view.addSubview(loading)
        
        bgImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalTo(view.snp_topMargin).inset(13.scaleX)
            $0.leading.equalToSuperview().inset(16.scaleX)
            $0.size.equalTo(CGSize(width: 44.scaleX, height: 44.scaleX))
        }
        
        gradientView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(descriptView.snp.top).inset(-12.scaleX)
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
        
        // Des
        descriptView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(continueButton.snp.top).inset(-16.scaleX)
        }
        
        // Continue
        continueButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16.scaleX)
            $0.bottom.equalTo(view.snp_bottomMargin).inset(44.scaleX)
            $0.height.equalTo(54.scaleX)
        }
        
        rtpView.snp.makeConstraints {
            $0.bottom.equalTo(view.snp_bottomMargin).inset(12.scaleX)
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
                var weeklyPrice = ""
                
                if let index = listProduct.firstIndex(where: { $0.id == Developer.weeklyTrialID}) {
                    wSelf.weeklyButton.updateWeekly(price: listProduct[index].price, symbol: listProduct[index].symbol)
                    weeklyPrice = listProduct[index].price
                }
                
                if let index = listProduct.firstIndex(where: { $0.id == Developer.yearlyID}) {
                    wSelf.yearlyButton.updateYearly(price: listProduct[index].price,
                                                    weeklyPrice: weeklyPrice,
                                                    symbol: listProduct[index].symbol)
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
        descriptView.changeTrialState(isTrial: false)
        isPickYearly = isYearly
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
        yearlyButton.isUserInteractionEnabled = !isDisable
        weeklyButton.isUserInteractionEnabled = !isDisable
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
        
        yearlyButton.rx.tap
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: { owner, _ in
                owner.updateStateButton(isYearly: true)
            })
            .disposed(by: disposeBag)
        
        weeklyButton.rx.tap
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

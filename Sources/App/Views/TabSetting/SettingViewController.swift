import Foundation
import UIKit
import SnapKit
import StoreKit
import SafariServices
import RxSwift
import RxCocoa

class SettingViewController: BaseViewController {
    private lazy var scrollView = UIScrollView()
    private lazy var contentView = UIView()
    private lazy var appLabel = UILabel()
    private lazy var appView = AppView()
    private lazy var ourAppLabel = UILabel()
    private lazy var appStackView = UIStackView()
    private lazy var aboutLabel = UILabel()
    private lazy var aboutStackView = UIStackView()
    
    var storeProductViewController = SKStoreProductViewController()
    
    let viewModel: SettingViewModel = .init()
    let jsonService = JsonService.shared
    let adsManager = AdsManager.shared
    let userDefault = UserDefaultService.shared
}

extension SettingViewController: SKStoreProductViewControllerDelegate {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Check show intersitial ad
        viewModel.updateDailyTime { _ in }
        displayIntersitialAd()
    }
    
    override func setupViews() {
        super.setupViews()

        //MARK: Setup views
        storeProductViewController.delegate = self
        
        scrollView.showsVerticalScrollIndicator = false
        
        appLabel.setText(text: "APP", color: AppColor.main)
        appLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        
        ourAppLabel.setText(text: "OUR APPS", color: AppColor.main)
        ourAppLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        
        appStackView.setupSetting()
        appStackView.addTopBottomPadding(top: 6, bottom: 6)
        
        aboutLabel.setText(text: "ABOUT", color: AppColor.main)
        aboutLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        
        aboutStackView.setupSetting()
        
        //MARK: Setup constrains
        addTabbarHeader()
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(appLabel)
        contentView.addSubview(appView)
        contentView.addSubview(ourAppLabel)
        contentView.addSubview(appStackView)
        contentView.addSubview(aboutLabel)
        contentView.addSubview(aboutStackView)
        
        scrollView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(tabbarHeader.snp.bottom)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.width.equalToSuperview()
        }
        
        appLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20.scaleX)
            $0.leading.equalToSuperview().inset(16.scaleX)
        }
        
        appView.snp.makeConstraints {
            $0.top.equalTo(appLabel.snp.bottom).inset(-10.scaleX)
            $0.leading.trailing.equalToSuperview().inset(16.scaleX)
        }
        
        ourAppLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16.scaleX)
            $0.top.equalTo(appView.snp.bottom).inset(-40.scaleX)
        }
        
        appStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16.scaleX)
            $0.top.equalTo(ourAppLabel.snp.bottom).inset(-10.scaleX)
        }
        
        aboutLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16.scaleX)
            $0.top.equalTo(appStackView.snp.bottom).inset(-40.scaleX)
        }
        
        aboutStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16.scaleX)
            $0.top.equalTo(aboutLabel.snp.bottom).inset(-10.scaleX)
            $0.bottom.equalToSuperview().inset(20.scaleX)
        }
        
        configInit()
    }
    
    func configInit() {
        parseDataApp()
        parseDataAbout()
    }
    
    func parseDataApp() {
        jsonService.getDataFromFileName(fileName: "data_app") { [weak self] (result: [SettingModel]?) in
            guard let wSelf = self else { return }
            if let result = result {
                for (index, model) in result.enumerated() {
                    let appItemView = AppItemView()
                    appItemView.updateViews(icon: model.thumb, title: model.name, isLast: index == result.count - 1 ? true : false)
                    wSelf.appStackView.addArrangedSubview(appItemView)
                    
                    appItemView.buttonAction = { [weak self]  in
                        guard let wSelf = self else { return }
                        wSelf.openApp(idApp: model.id) { _ in }
                    }
                }
            }
        }
    }
    
    func parseDataAbout() {
        jsonService.getDataFromFileName(fileName: "data_about") { [weak self] (result: [SettingModel]?) in
            guard let wSelf = self else { return }
            if let result = result {
                for (index, model) in result.enumerated() { // add subview
                    let aboutItemView = AboutItemView()
                    aboutItemView.updateViews(icon: model.thumb, title: model.name, isLast: index == result.count - 1 ? true : false)
                    wSelf.aboutStackView.addArrangedSubview(aboutItemView)
                    
                    aboutItemView.buttonAction = { [weak self] in
                        guard let wSelf = self else { return }
                        wSelf.configAbout(index: index)
                    }
                }
            }
        }
    }
    
    // MARK: open App
    func presentStoreProductViewController(_ idApp: String, completion: @escaping(Bool) -> Void ) {
        let storeProductViewController = SKStoreProductViewController()
        storeProductViewController.delegate = self
        let parameters = [SKStoreProductParameterITunesItemIdentifier: idApp]
        storeProductViewController.loadProduct(withParameters: parameters) { (loaded, error) in
            if loaded {
                self.present(storeProductViewController, animated: true) {
                    completion(true)
                }
            } else {
                // Handle error
                completion(false)
                
            }
        }
    }
    
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func openApp(idApp: String, completion: @escaping(Bool) -> Void) {
        DispatchQueue.main.async {
            if let presentedViewController = self.presentedViewController {
                // Dismiss the currently presented view controller before presenting the SKStoreProductViewController
                presentedViewController.dismiss(animated: false) {
                    self.presentStoreProductViewController(idApp) { _ in
                        completion(true)
                    }
                }
            } else {
                // No view controller is currently presented, so directly present the SKStoreProductViewController
                self.presentStoreProductViewController(idApp) { _ in
                    completion(true)
                }
            }
        }
    }
    
    func configAbout(index: Int) {
        switch index {
        case 0 :
            if let name = URL(string: Developer.urlApp), !name.absoluteString.isEmpty {
                DispatchQueue.main.async {
                    let objectsToShare = [name]
                    let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                    self.present(activityVC, animated: true, completion: nil)
                }
            }
        case 1:
            openUrl(url: Developer.termOfUse)
        case 2:
            openUrl(url: Developer.privacyPolicy)
        case 3:
            openUrl(url: Developer.conntacUs)
        case 4:
            if let mailComposeViewController = MailController.shared.mailComposeViewController() {
                DispatchQueue.main.async {
                    mailComposeViewController.setToRecipients(["\(Developer.supportEmail)"])
                    mailComposeViewController.setSubject("Feedback AI Headshot Beta")
                    self.present(mailComposeViewController, animated:true, completion:nil)
                }
            }
            
        case 5:
            openUrl(url: Developer.conntacUs)
        default: break
        }
    }
    
    override func setupRx() {
        super.setupRx()
        
        // Header
        configTapPremiumTabbarHeader()
        
        tabbarHeader.galleryButton.rx.tap
            .throttle(.milliseconds(300), scheduler: scheduler.main)
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: { owner, _ in
                let galleryVC = GalleryViewController()
                self.navigationController?.pushViewController(galleryVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        appView.changeIconButton.rx.tap
            .throttle(.milliseconds(300), scheduler: scheduler.main)
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: { owner, _ in
                owner.navigationController?.pushViewController(LogoViewController(), animated: true)
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

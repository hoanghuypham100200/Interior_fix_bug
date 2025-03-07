import Foundation
import NVActivityIndicatorView
import IQKeyboardManagerSwift
import SnapKit
import UIKit
import RxSwift

class TabBarViewController: UITabBarController {
    let userDefault = UserDefaultService.shared
    
    private lazy var loadingView = NVActivityIndicatorView(frame: .zero, type: .circleStrokeSpin, color: AppColor.yellow_normal_hover, padding: 0)
    
    // Rewarded ad option popup
    private lazy var rwOpacityButton = UIButton()
    private lazy var rwOptionPopup = RewardedAdOptionView()
    
    private lazy var proccessingView = ProccessingView()
    
    let disposeBag = DisposeBag()
    private let viewModel = TabbarViewModel.init()
    private let rewardedAdService = RewardedAdService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setValue(CustomTabBar(), forKey: "tabBar")
        setupViewController()
        setupUI()
        setupRx()
    }
    
    func setupUI() {
        
        self.delegate = self
        rewardedAdService.delegate = self
        tabBar.backgroundColor = AppColor.light
        tabBar.unselectedItemTintColor = AppColor.yellow_dark
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10, weight: .medium), NSAttributedString.Key.foregroundColor: AppColor.yellow_normal_hover], for: .normal)
        
        // rw option
        rwOpacityButton.backgroundColor = AppColor.text_black.withAlphaComponent(0.85)
        rwOpacityButton.isHidden = true
        
        proccessingView.isHidden = true
        
        // Rw popup
        view.addSubview(rwOpacityButton)
        rwOpacityButton.addSubview(rwOptionPopup)
        
        view.addSubview(loadingView)
        view.addSubview(proccessingView)
        
        // Rw popup
        rwOpacityButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        rwOptionPopup.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(320.scaleX)
        }
        
        loadingView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 50.scaleX, height: 50.scaleX))
            $0.center.equalToSuperview()
        }
        
        proccessingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    
    }
    
    func setupViewController() {
        viewControllers = [createTab, historyTab, settingTab]
    }
    
    lazy var createTab: UIViewController = {
        var imageSelected: UIImage?
        var imageUnSelect: UIImage?
        
        if #available(iOS 18.0, *) {
            imageUnSelect = UIImage(systemName: "wand.and.sparkles")?.setIconSystem(name: "wand.and.sparkles", color: AppColor.yellow_dark, weight: .bold).withRenderingMode(.alwaysOriginal)
            imageSelected = UIImage(systemName: "wand.and.sparkles")?.setIconSystem(name: "wand.and.sparkles", color: AppColor.yellow_normal_hover, weight: .bold).withRenderingMode(.alwaysOriginal)
        }else {
            imageUnSelect = R.image.tab_create_unselect()?.withRenderingMode(.alwaysOriginal)
            imageSelected = R.image.tab_create_selected()?.withRenderingMode(.alwaysOriginal)
        }
        
        let createTabItem = UITabBarItem(title: "Create", image: imageUnSelect , selectedImage: imageSelected )
        let createNavTab = CreateViewController()
        createNavTab.tabBarItem = createTabItem
        return createNavTab
    }()
    
    lazy var historyTab: UIViewController = {
        var imageSelected: UIImage?
        var imageUnSelect: UIImage?
        
        if #available(iOS 18.0, *) {
            imageUnSelect = UIImage(systemName: "clock.fill")?.setIconSystem(name: "clock.fill", color: AppColor.yellow_dark, weight: .bold).withRenderingMode(.alwaysOriginal)
            imageSelected = UIImage(systemName: "clock.fill")?.setIconSystem(name: "clock.fill", color: AppColor.yellow_normal_hover, weight: .bold).withRenderingMode(.alwaysOriginal)
        }else {
            imageUnSelect = R.image.tab_history_unselect()?.withRenderingMode(.alwaysOriginal)
            imageSelected = R.image.tab_history_selected()?.withRenderingMode(.alwaysOriginal)
        }
        
        let historyTabItem = UITabBarItem(title: "History", image: imageUnSelect , selectedImage: imageSelected )
        let historyNavTab =  HistoryViewController()
        historyNavTab.tabBarItem = historyTabItem
        return historyNavTab
    }()
    
    lazy var settingTab: UIViewController = {
        var imageSelected: UIImage?
        var imageUnSelect: UIImage?
        
        if #available(iOS 18.0, *) {
            imageUnSelect = UIImage(systemName: "gearshape.fill")?.setIconSystem(name: "gearshape.fill", color: AppColor.yellow_dark, weight: .bold).withRenderingMode(.alwaysOriginal)
            imageSelected = UIImage(systemName: "gearshape.fill")?.setIconSystem(name: "gearshape.fill", color: AppColor.yellow_normal_hover, weight: .bold).withRenderingMode(.alwaysOriginal)
        }else {
            imageUnSelect = R.image.tab_setting_unselect()?.withRenderingMode(.alwaysOriginal)
            imageSelected = R.image.tab_setting_selected()?.withRenderingMode(.alwaysOriginal)
        }
        
        let settingTabItem = UITabBarItem(title: "Setting" , image: imageUnSelect , selectedImage: imageSelected )
        let settingNavTab = SettingViewController()
        settingNavTab.tabBarItem = settingTabItem
        return settingNavTab
    }()
    
    private func setupRx() {
        // MARK: Rw popup
        rwOpacityButton.rx.tap
            .throttle(.milliseconds(300), scheduler: scheduler.main)
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: { owner, _ in
                owner.updatehideRW()
            })
            .disposed(by: disposeBag)
        
        rwOptionPopup.premiumButton.rx.tap
            .throttle(.milliseconds(300), scheduler: scheduler.main)
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: { owner, _ in
                // Hide rw popup
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    owner.updatehideRW()
                }
                // Open ds
                owner.openDS()
            })
            .disposed(by: disposeBag)
        
        rwOptionPopup.watchAdButton.rx.tap
            .throttle(.milliseconds(300), scheduler: scheduler.main)
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: { owner, _ in
                owner.loadRwAd()
            })
            .disposed(by: disposeBag)
        
        proccessingView.cancelButton.rx.tap
            .throttle(.milliseconds(300), scheduler: scheduler.main)
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: { owner, _ in
                CreateViewModel.shared.updateCancelGenView(stopGen: true)
                owner.hideProccessingView()
            })
            .disposed(by: disposeBag)
        
        viewModel.showRwPopupCreateOsb
            .observe(on: scheduler.main)
            .withUnretained(self)
            .subscribe(onNext: { owner, isShow in
                isShow ? owner.showRwPopup() : owner.hideRwPopup()
            })
            .disposed(by: disposeBag)
        
        viewModel.showProccessingViewOsb
            .observe(on: scheduler.main)
            .withUnretained(self)
            .subscribe(onNext: { owner, isShow in
                isShow ? owner.showProccessingView() : owner.hideProccessingView()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: Loading
    func loadingState(isStart: Bool) {
        isStart ? loadingView.startAnimating() : loadingView.stopAnimating()
        rwOpacityButton.isUserInteractionEnabled = !isStart
    }
    
    func loadRwAd() {
        // Start loading
        loadingState(isStart: true)
        
        rewardedAdService.showAd(on: self)
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: { owner, hasAd in
                // Stop loading
                owner.loadingState(isStart: false)

                // Hide rw popup
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    owner.updatehideRW()
                }
                
                if !hasAd {
                    // No ad -> Open ds
                    owner.openDS()
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    func updatehideRW() {
        viewModel.updateShowRwPopupCreate(isShow: false)
    }
    
    func openDS() {
        let dsVC = AppRouter.makeDirectStoreMain(value: Value.ad.rawValue)
        present(dsVC, animated: true)
    }
    
    // MARK: Rw popup
    // Hide rw ad poup
    func hideRwPopup() {
        rwOpacityButton.isHidden = true
    }
    
    // Show rw ad popup
    func showRwPopup() {
        rwOpacityButton.isHidden = false
        rwOptionPopup.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 5.0,
                       options: .allowUserInteraction,
                       animations: {
            self.rwOptionPopup.alpha = 1
            self.rwOptionPopup.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: nil)
    }
    
    // MARK: Rw popup
    // Hide rw ad poup
    func hideProccessingView() {
        proccessingView.isHidden = true
    }
    
    // Show rw ad popup
    func showProccessingView() {
        proccessingView.isHidden = false
    }
    
}



extension TabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
            guard tabBar.items != nil else { return }
            guard let index = viewControllers?.firstIndex(of: viewController) else { return }
            if let selectedItemView = tabBar.subviews[index + 1].subviews.first as? UIImageView {
                if #available(iOS 18.0, *) {
                    selectedItemView.addSymbolEffect(.bounce, animated: true)
                }
            }
    }
}

extension TabBarViewController: RewardedAdServiceDelegate {
    func rwAdDidDismiss() {
        CreateViewModel.shared.updateGenWhenRwCreateDismiss(isGen: true)
    }
    
}


import Foundation
import SnapKit
import UIKit

class RootViewController: BaseViewController {
    private lazy var bgImageView = UIImageView()
    private lazy var nameAppLabel = UILabel()
    
    let viewModel = RootViewModel.init()
    let obViewModel = OnboardingViewModel.shared
    let userDefault = UserDefaultService.shared
    
    override func setupViews() {
        super.setupViews()
         
        bgImageView.image = R.image.img_splash_screen()
        bgImageView.contentMode = .scaleAspectFill
        bgImageView.clipsToBounds = true
        
        nameAppLabel.font = UIFont.appFont(size: 28)
        nameAppLabel.setText(text: "Interior AI", color: AppColor.bg_1)
        
        view.addSubview(bgImageView)
        view.addSubview(nameAppLabel)
        
        bgImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        nameAppLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
       
    }
    
    override func setupRx() {
        super.setupRx()
        
        // MARK: Check proxy
        guard !isConnectedToProxy() else {
            popupProxy()
            return
        }
    
        viewModel.didGetConfigOsb
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: { owner, value in
                
                guard value else { return }
            
                owner.checkDailyUsage()
                owner.preloadAds()
                
                guard owner.userDefault.isFirstLaunch else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.navigationController?.pushViewController(TabBarViewController(), animated: true)
                    }
                    return
                }

                #if DEBUG
                owner.navigationController?.pushViewController(OnboardingV1ViewController(), animated: true)
                #else
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    switch owner.obViewModel.obConfigValue {
                    case OnboardingType.onboardingV1.rawValue:
                        owner.navigationController?.pushViewController(OnboardingV1ViewController(), animated: true)
                    default:
                        owner.navigationController?.pushViewController(OnboardingV1ViewController(), animated: true)
                    }
                }
                #endif
            })
            .disposed(by: disposeBag)
    }
}

extension RootViewController {
    func checkDailyUsage() {
//        let viewModel = ExploreViewModel.shared
//        viewModel.updateDailyTime { _ in }
    }
    
    func preloadAds() {
        // MARK: Interstitial
        InterstitialAdService.shared.preloadAd()
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: { owner, value in
                print("Preload Interstitial: \(value)")
            })
            .disposed(by: disposeBag)
        
        // MARK: App Open
        AppOpenAdService.shared.preloadAd()
            .subscribe(onSuccess: { [weak self] appOpenAd in
                guard let _ = self else { return }
                print("Preload App Open: successfully.")
            }, onFailure: { error in
                print("Preload App Open: Failed to preload ad: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
}

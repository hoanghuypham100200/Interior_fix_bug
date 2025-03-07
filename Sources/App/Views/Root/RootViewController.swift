import Foundation
import SnapKit
import UIKit

class RootViewController: BaseViewController {
    private lazy var nameAppLabel = UILabel()
    private lazy var poweredByLabel = UILabel()
    private lazy var AiLabel = UILabel()

    let viewModel = RootViewModel.init()
    let obViewModel = OnboardingViewModel.shared
    let userDefault = UserDefaultService.shared
    
    override func setupViews() {
        super.setupViews()
         
        nameAppLabel.font = UIFont.appFont(size: 48)
        nameAppLabel.setText(text: "Interior", color: AppColor.text_black)
        
        poweredByLabel.font = UIFont.systemFont(ofSize: 16,weight: .regular)
        poweredByLabel.setText(text: "Powered by", color: AppColor.text_black)
        
        AiLabel.font = UIFont.systemFont(ofSize: 20,weight: .bold)
        AiLabel.setText(text: "A.I.", color: AppColor.text_black)
        
        view.addSubview(nameAppLabel)
        view.addSubview(poweredByLabel)
        view.addSubview(AiLabel)
        
        nameAppLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        poweredByLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(34)
        }
        
        AiLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(poweredByLabel.snp.bottom)
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

import Foundation
import UIKit
import SnapKit
import PanModal

protocol DailyLimitDelegate: NSObjectProtocol {
    func openDs(value: String)
}

class DailyLimitModal: BaseViewController, PanModalPresentable {
    private lazy var indicatorView = UIView()
    private lazy var titleLabel = UILabel()
    private lazy var descriptionLabel = UILabel()
    private lazy var thumbImageView = UIImageView()
    private lazy var premiumButton = UIButton()
    
    let userDefault = UserDefaultService.shared
    let createViewModel = CreateViewModel.shared
    var value = Value.ad.rawValue
    
    var delegate: DailyLimitDelegate?
    
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(Developer.isHasNortch ?  586 : 480)
    }

    var longFormHeight: PanModalHeight {
        return .contentHeight( Developer.isHasNortch ?  586 : 480)
    }
    
    var cornerRadius: CGFloat {
        return 30.scaleX
    }
    
    var showDragIndicator: Bool {
        return false
    }
}

extension DailyLimitModal {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func setupViews() {
        super.setupViews()
        
        indicatorView.cornerRadius = 2.5
        indicatorView.backgroundColor = AppColor.modal_indicator
        
        titleLabel.textColor = AppColor.text_black_patriona
        titleLabel.font = UIFont.appFont(size: 24)
        
        descriptionLabel.textColor =  AppColor.text_gray_2
        descriptionLabel.font = .systemFont(ofSize: 14, weight: .medium)
        descriptionLabel.numberOfLines = 2
        
        thumbImageView.image = R.image.image_premium_modal()
        thumbImageView.contentMode = .scaleAspectFit
        
        premiumButton.setupBaseButton(title:"Go Premium", icon: R.image.ic_sparkles(), textColor: AppColor.text_black, backgroundColor: AppColor.guRed, radius: 20, font: UIFont.systemFont(ofSize: 16, weight: .semibold))
        
        //MARK: Setup views
        view.addSubview(indicatorView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(thumbImageView)
        view.addSubview(premiumButton)
        
        indicatorView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15.scaleX)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 60.scaleX, height: 5))
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(indicatorView.snp.bottom).inset(-40.scaleX)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).inset(-15.scaleX)
        }
        
        thumbImageView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(descriptionLabel.snp.bottom).inset(-44.scaleX)
            $0.height.equalTo(161.scaleX)
        }
        
        premiumButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16.scaleX)
            $0.height.equalTo(54.scaleX)
            $0.bottom.equalTo(view.snp_bottomMargin).inset(39.scaleX)
        }
        
    }
    
    func updateDailyLimit(usage: Int, free: Int) {
        let usegeLeft = usage > free ? free : usage
        titleLabel.text =  "Daily Limit: \(usegeLeft)/\(free)"
        descriptionLabel.text = "The number of designs you can create per day is\n\(free). Upgrade to premium for unlimited generations!"
    }
    
    override func setupRx() {
        super.setupRx()
        
        premiumButton.rx.tap
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: {owner, indexPath in
                owner.dismiss(animated: true)
                owner.delegate?.openDs(value: owner.value)
            })
            .disposed(by: disposeBag)
    }
    
}


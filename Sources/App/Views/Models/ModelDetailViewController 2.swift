import Foundation
import SnapKit
import UIKit

protocol ModelDetailDelegate: NSObjectProtocol {
    
    func selectGenerateTab()
}

class ModelDetailViewController: BaseViewController {
    
    private lazy var scrollView = UIScrollView()
    private lazy var contentView = UIView()
    private lazy var modelThumbImageView = UIImageView()
    private lazy var modelNameLabel = UILabel()
    private lazy var modelDesLabel = UILabel()
    private lazy var iconLora = UIImageView()
    private lazy var iconCheckpoint = UIImageView()
    private lazy var iconPremium = UIImageView()
    private lazy var iconHighlight = UIImageView()
    private lazy var buttonView = MainButtonView()
    
    let viewModel: HomeViewModel = .init()
    
    var styleModel: StyleModel?
    weak var delegate: ModelDetailDelegate?
}

extension ModelDetailViewController {

    override func setupViews() {
        super.setupViews()
        
        // MARK: Setup views
        modelThumbImageView.contentMode = .scaleAspectFill
        modelThumbImageView.clipsToBounds = true
        modelThumbImageView.cornerRadius = 15.scaleX
        
        iconLora.setIcon(icon: R.image.tag_lora_detail()!)
        iconCheckpoint.setIcon(icon: R.image.tag_checkpoint()!)
        iconPremium.setIcon(icon: R.image.tag_premium()!)
        iconHighlight.setIcon(icon: R.image.icon_highlight()!)
        
        modelNameLabel.textColor = AppColor.whiteTextColor
        modelNameLabel.font = UIFont.appFont(size: 16, weight: .SemiBold)
        
        modelDesLabel.textColor = AppColor.whiteTextColor
        modelDesLabel.font = UIFont.appFont(size: 14)
        modelDesLabel.numberOfLines = 0

        buttonView.updateTitle(title: "Use Model")
        
        // MARK: Setup constraints
        addMainHeader()
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(modelThumbImageView)
        contentView.addSubview(modelNameLabel)
        contentView.addSubview(modelDesLabel)
        contentView.addSubview(iconLora)
        contentView.addSubview(iconCheckpoint)
        contentView.addSubview(iconPremium)
        contentView.addSubview(iconHighlight)
        view.addSubview(buttonView)
        
        scrollView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(mainHeader.snp.bottom)
            $0.bottom.equalTo(buttonView.snp.top)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        modelThumbImageView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview().inset(20.scaleX)
            $0.height.equalTo(modelThumbImageView.snp.width)
        }
        
        iconLora.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20.scaleX)
            $0.top.equalTo(modelThumbImageView.snp.bottom).inset(-12.scaleX)
            $0.size.equalTo(CGSize(width: 60.scaleX, height: 28.scaleX))
        }
        
        iconCheckpoint.snp.makeConstraints {
            $0.centerY.equalTo(iconLora)
            $0.leading.equalTo(iconLora.snp.trailing).inset(-5.scaleX)
            $0.size.equalTo(CGSize(width: 104.scaleX, height: 28.scaleX))
        }
        
        iconPremium.snp.makeConstraints {
            $0.centerY.equalTo(iconCheckpoint)
            $0.leading.equalTo(iconCheckpoint.snp.trailing).inset(-5.scaleX)
            $0.size.equalTo(CGSize(width: 89.scaleX, height: 28.scaleX))
        }
        
        modelNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20.scaleX)
            $0.top.equalTo(iconLora.snp.bottom).inset(-12.scaleX)
        }
        
        iconHighlight.snp.makeConstraints {
            $0.centerY.equalTo(modelNameLabel)
            $0.leading.equalTo(modelNameLabel.snp.trailing).inset(-2.scaleX)
            $0.trailing.lessThanOrEqualToSuperview().inset(20.scaleX)
            $0.size.equalTo(CGSize(width: 15.scaleX, height: 15.scaleX))
        }
        
        modelDesLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20.scaleX)
            $0.top.equalTo(modelNameLabel.snp.bottom).inset(-5.scaleX)
            $0.bottom.equalToSuperview().inset(10.scaleX)
        }
        
        buttonView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.snp_bottomMargin)
        }
        
        updateViews()
    }
    
    func updateViews() {
        guard let styleModel = styleModel else { return }
        let hasLora = !styleModel.loraID.isEmpty
        
        mainHeader.update(title: styleModel.name)
        modelNameLabel.text = styleModel.name
        modelDesLabel.text = styleModel.description
        iconHighlight.isHidden = !styleModel.highlighted
        iconLora.isHidden = !hasLora
        iconCheckpoint.isHidden = hasLora
        iconPremium.isHidden = UserDefaultService.shared.isPurchase ? true : (styleModel.isPremium ? false : true)
   
        iconLora.snp.updateConstraints {
            $0.leading.equalToSuperview().inset(!hasLora ? 15.scaleX : 20.scaleX)
            $0.top.equalTo(modelThumbImageView.snp.bottom).inset(-12.scaleX)
            $0.size.equalTo(CGSize(width: !hasLora ? 0 : 60.scaleX, height: 28.scaleX))
        }
        
        iconCheckpoint.snp.updateConstraints {
            $0.centerY.equalTo(iconLora)
            $0.leading.equalTo(iconLora.snp.trailing).inset(hasLora ? 0 : -5.scaleX)
            $0.size.equalTo(CGSize(width: hasLora ? 0 : 104.scaleX, height: 28.scaleX))
        }
        
        let url = URL(string: styleModel.thumbnail)
        guard let url = url else { return }

        modelThumbImageView.kf.setImage(with: url, options: [
            .progressiveJPEG(.init()),
            .callbackQueue(.mainAsync),
            .diskCacheExpiration(.never)]) { result in
            switch result {
            case .success(let value):
                print("\(value)")
            case .failure(let error):
                print("\(error.localizedDescription)")
            }
        }
    }
    
    override func setupRx() {
        super.setupRx()
        
        configTapMainHeader()
        
        buttonView.button.rx.tap
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: { owner, _ in
                
                guard let styleModel = owner.styleModel else { return }
                owner.viewModel.updateStylePicked(model: styleModel)
                owner.navigationController?.popViewController(animated: true)
                owner.delegate?.selectGenerateTab()
            })
            .disposed(by: disposeBag)
    }
}

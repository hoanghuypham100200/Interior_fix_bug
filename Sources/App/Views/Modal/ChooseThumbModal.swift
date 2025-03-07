import Foundation
import UIKit
import SnapKit
import PanModal

protocol ChooseThumbDelegate: NSObjectProtocol {
    func chooseThumb(isPhoto: Bool)
}

class ChooseThumbModal: BaseViewController, PanModalPresentable {
    private lazy var contentView =  UIView()
    private lazy var cameraButton = ChooseThumbModalButton()
    private lazy var photoButton = ChooseThumbModalButton()
    
    let userDefault = UserDefaultService.shared
    let createViewModel = CreateViewModel.shared
    
    weak var delegate: ChooseThumbDelegate?
    
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(260)
    }

    var longFormHeight: PanModalHeight {
        return .contentHeight(260)
    }
    
    var cornerRadius: CGFloat {
        return 30.scaleX
    }
    
    var showDragIndicator: Bool {
        return false
    }
}

extension ChooseThumbModal {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Check show intersitial ad
        displayIntersitialAd()
    }

    override func setupViews() {
        super.setupViews()
        
        //MARK: Setup views
        view.layer.cornerRadius = 30.scaleX
        view.clipsToBounds = true
        
        cameraButton.baseSetup( title: "Camera", icon: "camera.fill", weight: .regular)
        
        photoButton.baseSetup( title: "Photos", icon: "photo.fill", weight: .regular)
        
        modalHeader.update(title: "Add With")
        
        //MARK: Setup constrains
        addModalHeader()
        
        view.addSubview(contentView)
        contentView.addSubview(photoButton)
        contentView.addSubview(cameraButton)
        
        contentView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(100.scaleX)
            $0.top.equalTo(modalHeader.snp.bottom).inset(-23.scaleX)
        }
        
        photoButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.size.equalTo(CGSize(width: 163.scaleX, height: 100.scaleX))
        }
        
        cameraButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.leading.equalTo(photoButton.snp.trailing).inset(-35.scaleX)
            $0.size.equalTo(CGSize(width: 163.scaleX, height: 100.scaleX))
        }
    }
    
    override func setupRx() {
        super.setupRx()
        photoButton.button.rx.tap
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: {owner, indexPath in
                owner.dismiss(animated: true)
                owner.delegate?.chooseThumb(isPhoto: true)
            })
            .disposed(by: disposeBag)
        
        cameraButton.button.rx.tap
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: {owner, indexPath in
                owner.dismiss(animated: true)
                owner.delegate?.chooseThumb(isPhoto: false)
            })
            .disposed(by: disposeBag)
    }
    
}



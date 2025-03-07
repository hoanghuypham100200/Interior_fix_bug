import Foundation
import RxSwift
import SnapKit
import UIKit

class LogoViewController: BaseViewController {
    
    private lazy var logoCollectionView = UICollectionView()
    private lazy var applyButton = UIButton()
    
    let viewModel = LogoViewModel.init()
    let userDefault = UserDefaultService.shared
    
    let appIconUseList = ["AppIcon_1"]
    let appIconShowList = ["app_icon_1"]
    var isFisrtLoad = true
    var iconPicked = ""
}

extension LogoViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Check show intersitial ad
        viewModel.updateDailyTime() { _ in}
        displayIntersitialAd()
        
        guard isFisrtLoad else { return }
        isFisrtLoad = false
        
        if let index = appIconUseList.firstIndex(where: { $0 == userDefault.logoApp }) {
            logoCollectionView.selectItem(at: IndexPath(row: index, section: 0), animated: false , scrollPosition: UICollectionView.ScrollPosition.centeredHorizontally)
            iconPicked = appIconUseList[index]
        } else {
            logoCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: false , scrollPosition: UICollectionView.ScrollPosition.centeredHorizontally)
            iconPicked = appIconUseList[0]
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        // MARK: Setup views
        screenHeader.update(title: "Change app icon")
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 110.scaleX, height: 110.scaleX)
        logoCollectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        logoCollectionView.register(LogoCell.self, forCellWithReuseIdentifier: LogoCell.identifier)
        logoCollectionView.dataSource = self
        logoCollectionView.delegate = self
        logoCollectionView.contentInset = UIEdgeInsets(top: 20.scaleX, left: 0, bottom: 20.scaleX, right: 0)
        logoCollectionView.setupCollectionView()
        
        applyButton.setupBaseButton(title:"Select", icon: UIImage(systemName: "checkmark") , textColor: AppColor.guBg, backgroundColor: AppColor.guRed, radius: 15, font: UIFont.systemFont(ofSize: 18, weight: .regular))
        applyButton.tintColor = AppColor.guBg
        // MARK: Setup constraints
        addScreenHeader()
        view.addSubview(logoCollectionView)
        view.addSubview(applyButton)
        
        logoCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20.scaleX)
            $0.top.equalTo(screenHeader.snp.bottom)
            $0.bottom.equalTo(applyButton.snp.top).inset(-13.scaleX)
        }
        
        applyButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16.scaleX)
            $0.bottom.equalTo(view.snp_bottomMargin).inset(30.scaleX)
            $0.size.equalTo(CGSize(width: 166.scaleX, height: 55.scaleX))
        }
    }
    
    override func setupRx() {
        super.setupRx()
        
        // Header
        actionBackScreenHeader()
        
        applyButton.rx.tap
            .observe(on: scheduler.main)
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                guard UIApplication.shared.supportsAlternateIcons else { return }
                owner.userDefault.logoApp = owner.iconPicked
                guard owner.iconPicked == owner.appIconUseList[0] else {
                    UIApplication.shared.setAlternateIconName(owner.userDefault.logoApp)
                    return
                }
                UIApplication.shared.setAlternateIconName(nil)
            })
            .disposed(by: disposeBag)
    }
}

extension LogoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appIconShowList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LogoCell.identifier, for: indexPath) as? LogoCell
        else { return .init() }
        cell.update(avatar: appIconShowList[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        iconPicked = appIconUseList[indexPath.row]
    }
}

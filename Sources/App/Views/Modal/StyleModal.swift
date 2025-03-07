import Foundation
import UIKit
import SnapKit
import PanModal



protocol ChangeStyleDelegate: NSObjectProtocol {
    func updateStyle(index: Int)
}

class StyleModal: BaseViewController, PanModalPresentable {
    public lazy var allStyleCollectionView = UICollectionView()
    
    let userDefault = UserDefaultService.shared
    let createViewModel = CreateViewModel.shared
    
    weak var delegate: ChangeStyleDelegate?
    
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight( Developer.isHasNortch ? 720 : 520)
    }

    var longFormHeight: PanModalHeight {
        return .contentHeight( Developer.isHasNortch ? 720 : 520)
    }
    
    var cornerRadius: CGFloat {
        return 30.scaleX
    }
    
    var showDragIndicator: Bool {
        return false
    }
}

extension StyleModal {
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
        
        modalHeader.update(title: "Select Style")
        
        let layoutStyle: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layoutStyle.minimumLineSpacing = 12
        layoutStyle.minimumInteritemSpacing = 0
        layoutStyle.scrollDirection = .vertical
        layoutStyle.itemSize = CGSize(width: (view.frame.width - 32)/2, height: 143.scaleX)
        allStyleCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layoutStyle)
        allStyleCollectionView.register(StyleModalCell.self, forCellWithReuseIdentifier: StyleModalCell.identifier)
        allStyleCollectionView.dataSource = self
        allStyleCollectionView.delegate = self
        allStyleCollectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 20.scaleX, right: 16)
        allStyleCollectionView.setupCollectionView()
        
        //MARK: Setup constrains
        addModalHeader()
        view.addSubview(allStyleCollectionView)

        allStyleCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalTo(modalHeader.snp.bottom)
        }
    }
}

extension StyleModal: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return createViewModel.styleConfigValue.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StyleModalCell.identifier, for: indexPath) as?  StyleModalCell else { return .init() }
        let style = createViewModel.styleConfigValue[indexPath.row]
        cell.setData(style: style)
        return cell
    }
}

extension StyleModal: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dismiss(animated: true)
        delegate?.updateStyle(index: indexPath.row)
    }
}




import Foundation
import UIKit
import SnapKit
import PanModal



protocol ChangeRoomDelegate: NSObjectProtocol {
    func updateRoom(index: Int)
}

class RoomModal: BaseViewController, PanModalPresentable {
    public lazy var roomCollectionView = UICollectionView()
    
    let userDefault = UserDefaultService.shared
    let createViewModel = CreateViewModel.shared
    
    weak var delegate: ChangeRoomDelegate?
    
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(480)
    }

    var longFormHeight: PanModalHeight {
        return .contentHeight(480)
    }
    
    var cornerRadius: CGFloat {
        return 30.scaleX
    }
    
    var showDragIndicator: Bool {
        return false
    }
}

extension RoomModal {
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
        
        modalHeader.update(title: "Select Room")
        
        let layout = AlignLeftFlowLayout()
        layout.minimumLineSpacing = 10.scaleX
        layout.minimumInteritemSpacing = 10.scaleX
        layout.scrollDirection = .vertical
        roomCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        roomCollectionView.register(RoomCell.self, forCellWithReuseIdentifier: RoomCell.identifier)
        roomCollectionView.setupCollectionView()
        roomCollectionView.contentInset = UIEdgeInsets(top: 38.scaleX, left: 16.scaleX, bottom: 20.scaleX, right: 16.scaleX)
        roomCollectionView.delegate = self
        roomCollectionView.dataSource = self

        //MARK: Setup constrains
        addModalHeader()
        view.addSubview(roomCollectionView)

        roomCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalTo(modalHeader.snp.bottom)
        }
    }
    
}

extension RoomModal: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        createViewModel.roomConfigValue.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RoomCell.identifier,for: indexPath) as? RoomCell
        else {
            return .init()
        }
        
        let room = createViewModel.roomConfigValue[indexPath.row]
        cell.updateData(room: room, isSelected: false)
     
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dismiss(animated: true)
        delegate?.updateRoom(index: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: CGRect.zero)
        let room = createViewModel.roomConfigValue[indexPath.row]
        
        label.text = room.title
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.sizeToFit()
        var cellWidth = label.frame.width + 25.scaleX
        guard let icon_width = calculateWidth(for: room.icon, pointSize: 16, weight: .regular, targetHeight: 19) else {
            return CGSize(width: cellWidth + 23.scaleX, height: 36.scaleX)
        }
        cellWidth = label.frame.width + icon_width + 25.scaleX
      
        return CGSize(width: cellWidth, height: 36.scaleX)
    }
    
    func calculateWidth(for systemName: String, pointSize: CGFloat, weight: UIImage.SymbolWeight, targetHeight: CGFloat) -> CGFloat? {
        let config = UIImage.SymbolConfiguration(pointSize: pointSize, weight: weight)
        if let image = UIImage(systemName: systemName, withConfiguration: config) {
            let originalWidth = image.size.width
            let originalHeight = image.size.height
            let width = targetHeight * (originalWidth / originalHeight)
            return width
        }
        return nil
    }
}



import Foundation
import SnapKit
import UIKit

class SelectRoomView: UIView {
    private lazy var iconRoomImageView = UIImageView()
    private lazy var titleRoomLabel = UILabel()
    public lazy var viewAllButton = ViewAllButton()
    public lazy var roomCollectionView = UICollectionView()
    
    let userDefault = UserDefaultService.shared
    
    var roomTypes:[RoomTypeModel] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        iconRoomImageView.setIconSystem(name: "rhombus", color: AppColor.yellow_dark, weight: .regular)
        
        titleRoomLabel.setText(text: "Select Room", color: AppColor.text_black)
        titleRoomLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        roomCollectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        roomCollectionView.register(RoomCell.self, forCellWithReuseIdentifier: RoomCell.identifier)
        roomCollectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        roomCollectionView.setupCollectionView()
        roomCollectionView.delegate = self
        roomCollectionView.dataSource = self
    }
    
    private func setupConstraints() {
        addSubview(iconRoomImageView)
        addSubview(titleRoomLabel)
        addSubview(viewAllButton)
        addSubview(roomCollectionView)
        
        iconRoomImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16.scaleX)
            $0.top.equalToSuperview()
            $0.size.equalTo(CGSize(width: 16.scaleX, height: 19.scaleX))
        }
        
        titleRoomLabel.snp.makeConstraints {
            $0.leading.equalTo(iconRoomImageView.snp.trailing).inset(-5.scaleX)
            $0.centerY.equalTo(iconRoomImageView)
        }
        
        viewAllButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16.scaleX)
            $0.size.equalTo(CGSize(width: 70.scaleX, height: 17.scaleX))
            $0.centerY.equalTo(iconRoomImageView)
        }
        
        roomCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(iconRoomImageView.snp.bottom).inset(-15.scaleX)
            $0.height.equalTo(36.scaleX)
        }
    }
    
    func setData(roomTypes: [RoomTypeModel]) {
        self.roomTypes = roomTypes
        roomCollectionView.reloadData()
        roomCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .centeredHorizontally)
    }
}

extension SelectRoomView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return roomTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RoomCell.identifier, for: indexPath) as?  RoomCell else { return .init() }
        
        let room = roomTypes[indexPath.row]
        
        let index = roomTypes.firstIndex(where: {$0.id == userDefault.configSetting.roomId})
        cell.updateData(room: room, isSelected: indexPath.row == index )
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: CGRect.zero)
        let room = roomTypes[indexPath.row]
        
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
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


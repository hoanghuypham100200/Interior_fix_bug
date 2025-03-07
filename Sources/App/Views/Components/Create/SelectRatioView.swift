
import Foundation
import SnapKit
import UIKit

class SelectRatioView: UIView {
    private lazy var iconRatioImageView = UIImageView()
    private lazy var titleRatioLabel = UILabel()
    public lazy var ratioCollectionView = UICollectionView()
    
    let userDefault = UserDefaultService.shared
    
    var listRatio:[RatioConfigModel] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        iconRatioImageView.setIconSystem(name: "rectangle.3.group", color: AppColor.yellow_dark, weight: .regular)
        
        titleRatioLabel.setText(text: "Select Ratio", color: AppColor.text_black)
        titleRatioLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
       
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10.scaleX
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 94.scaleX, height: 36.scaleX)
        ratioCollectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        ratioCollectionView.register(RatioCell.self, forCellWithReuseIdentifier:  RatioCell.identifier)
        ratioCollectionView.contentInset = UIEdgeInsets(top: 0, left: 16.scaleX, bottom: 0, right: 16.scaleX)
        ratioCollectionView.setupCollectionView()
        ratioCollectionView.delegate = self
        ratioCollectionView.dataSource = self
        ratioCollectionView.clipsToBounds = false
    }
    
    private func setupConstraints() {
        addSubview(iconRatioImageView)
        addSubview(titleRatioLabel)
        addSubview(ratioCollectionView)
        
        iconRatioImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16.scaleX)
            $0.top.equalToSuperview()
            $0.size.equalTo(CGSize(width: 26.scaleX, height: 19.scaleX))
        }
        
        titleRatioLabel.snp.makeConstraints {
            $0.leading.equalTo(iconRatioImageView.snp.trailing).inset(-5.scaleX)
            $0.centerY.equalTo(iconRatioImageView)
        }
        
        ratioCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(iconRatioImageView.snp.bottom).inset(-15.scaleX)
            $0.height.equalTo(36.scaleX)
        }
    }
    
    func setData(ratio: [RatioConfigModel]) {
        listRatio = ratio
        ratioCollectionView.reloadData()
        var index = 0
        if let indexRatio = ratio.firstIndex(where: {$0.id == userDefault.configSetting.ratioId }) {
            index = indexRatio
        }
        ratioCollectionView.selectItem(at: IndexPath(item: index, section: 0), animated: false, scrollPosition: .centeredHorizontally)
    }
}

extension SelectRatioView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listRatio.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RatioCell.identifier, for: indexPath) as? RatioCell else { return .init() }
        
        let ratio = listRatio[indexPath.row]
        cell.updateData(ratio: ratio)
        return cell
    }
    
}







import Foundation
import SnapKit
import UIKit

class ExampleRetouchView: UIView {
    private lazy var containerView = UIView()
    private lazy var titleLabel = UILabel()
    public lazy var exampleCollectionView = UICollectionView()
    var example: [ExampleRetouchModel] = []
    var selectAction: ((ExampleRetouchModel?) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        titleLabel.textColor = .black
        titleLabel.text = "Example"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12.scaleX
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 110.scaleX , height: Developer.isHasNortch ? 144.scaleX : 120.scaleX )
        exampleCollectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        exampleCollectionView.register(ExampleCell.self, forCellWithReuseIdentifier:  ExampleCell.identifier)
        exampleCollectionView.contentInset = UIEdgeInsets(top: 0, left: 16.scaleX, bottom: 0, right: 16.scaleX)
        exampleCollectionView.setupCollectionView()
        exampleCollectionView.delegate = self
        exampleCollectionView.dataSource = self
        exampleCollectionView.clipsToBounds = false
    }
    
    private func setupConstraints() {
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(exampleCollectionView)
        
        containerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(33.scaleX)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(16.scaleX)
        }
        
        exampleCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).inset(-15.scaleX)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Developer.isHasNortch ? 144.scaleX : 100.scaleX)
        }
    }
    
    func setData(example: [ExampleRetouchModel]) {
        self.example = example
        exampleCollectionView.reloadData()
    }
    

}

extension ExampleRetouchView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return example.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExampleCell.identifier, for: indexPath) as? ExampleCell else { return .init() }
        let example = example[indexPath.row]
        cell.setData(example: example)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let exmaple = example[indexPath.row]
        selectAction?(exmaple)
        
    }
    
}





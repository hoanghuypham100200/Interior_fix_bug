
import Foundation
import SnapKit
import UIKit

class SelectStyleView: UIView {
    private lazy var titleStyleLabel = UILabel()
    public lazy var viewAllButton = ViewAllButton()
    public lazy var styleCollectionView = UICollectionView()
    
    var styles: [StyleConfigModel] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        
        titleStyleLabel.setText(text: "Style", color: AppColor.text_black)
        titleStyleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10.scaleX
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 83.scaleX, height: 83.scaleX)
        styleCollectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        styleCollectionView.register(StyleCell.self, forCellWithReuseIdentifier: StyleCell.identifier)
        styleCollectionView.contentInset = UIEdgeInsets(top: 0, left: 16.scaleX, bottom: 0, right: 16.scaleX)
        styleCollectionView.setupCollectionView()
        styleCollectionView.delegate = self
        styleCollectionView.dataSource = self
    }
    
    private func setupConstraints() {
        addSubview(titleStyleLabel)
        addSubview(viewAllButton)
        addSubview(styleCollectionView)
        
        
        titleStyleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16.scaleX)
            $0.top.equalToSuperview()
            
        }
        
        viewAllButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16.scaleX)
            $0.size.equalTo(CGSize(width: 70.scaleX, height: 17.scaleX))
            $0.centerY.equalTo(titleStyleLabel)
        }
        
        styleCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(titleStyleLabel.snp.bottom).inset(-10.scaleX)
            $0.height.equalTo(83.scaleX)
        }
    }
    
    func setData(styles: [StyleConfigModel]) {
        self.styles = styles
        styleCollectionView.reloadData()
        styleCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .centeredHorizontally)
    }
}

extension SelectStyleView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return styles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StyleCell.identifier, for: indexPath) as? StyleCell else { return .init() }
        let style = styles[indexPath.row]
        cell.setData(style: style)
        return cell
    }
    
}



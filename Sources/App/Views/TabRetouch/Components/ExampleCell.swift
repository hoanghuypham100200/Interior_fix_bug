import Foundation
import UIKit
import SnapKit
import Kingfisher

class ExampleCell: BaseCollectionViewCell {
    private lazy var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstrains()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupViews() {
       
        imageView.image = R.image.img_ob()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        
    }
    
    func setupConstrains() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    

    
    func setData(example: ExampleRetouchModel) {
        imageView.loadImageKF(thumbURL: example.thumbUrl) { _ in}
    }
    
    override var isSelected: Bool {
        didSet {
//            contentView.backgroundColor = isSelected ? AppColor.guRed : AppColor.bg_ds
//            contentView.layer.borderWidth = isSelected ? 0 : 1
            
        }
    }
    
}


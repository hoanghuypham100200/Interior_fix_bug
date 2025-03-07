import Foundation
import UIKit
import SnapKit
import Kingfisher

class ImageCell: BaseCollectionViewCell {
   
    public lazy var ImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstrains()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupViews() {
       
        ImageView.contentMode = .scaleAspectFit
        ImageView.clipsToBounds = true
        ImageView.layer.cornerRadius = 15
        ImageView.isUserInteractionEnabled = true
        ImageView.image = R.image.bg_choose_thumb()
      
        
    }
    
    func setupConstrains() {
        
        addSubview(ImageView)
        
        ImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()

        }
        
      

    }
    public func update(artWorkModel: ArtworkModel) {
        ImageView.loadImageKF(thumbURL: artWorkModel.url) { _ in }

    }
}

import Foundation
import SnapKit
import UIKit

class GalleryScreenHeader: UIView {
    public lazy var backButton = UIButton()
    private lazy var titleLabel = UILabel()
    public lazy var deleteModeButton = UIButton()
    
//    private lazy var deleteModeView = UIView()
    public lazy var deleteButton = UIButton()
    public lazy var doneButton = UIButton()
    
    public lazy var isDeleteMode = false {
        didSet {
            if (isDeleteMode) {
                titleLabel.isHidden = true
                deleteModeButton.isHidden = true
                
                deleteButton.isHidden = false
                doneButton.isHidden = false
                

            } else {
                titleLabel.isHidden = false
                deleteModeButton.isHidden = false
                
                deleteButton.isHidden = true
                doneButton.isHidden = true
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        backButton.setImage(R.image.img_back(), for: .normal)
        backButton.imageView?.contentMode = .scaleAspectFit
        
        titleLabel.textColor = AppColor.text_black_patriona
        titleLabel.font = UIFont.appFont(size: 24)
        
        deleteModeButton.setImage(UIImage(systemName: "pencil.line", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)), for: .normal)
        deleteModeButton.backgroundColor = .black
        deleteModeButton.tintColor = .white
        deleteModeButton.layer.cornerRadius = 20
        
        deleteButton.setTitle( "Delete", for: .normal)
        deleteButton.backgroundColor = AppColor.guRed
        deleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        deleteButton.layer.cornerRadius = 20
        deleteButton.isHidden = true

        
        doneButton.setTitle( "Done", for: .normal)
        doneButton.backgroundColor = .black
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        doneButton.layer.cornerRadius = 20
        doneButton.isHidden = true
    }
    
    private func setupConstraints() {
        addSubview(backButton)
        addSubview(titleLabel)
        addSubview(deleteModeButton)
        addSubview(deleteButton)
        addSubview(doneButton)



        
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20.scaleX)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 40.scaleX, height: 40.scaleX))
        }
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        deleteModeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20.scaleX)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 40.scaleX, height: 40.scaleX))
        }
        
        doneButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16.scaleX)
            $0.size.equalTo(CGSize(width: 70, height: 40))
        }
        
        deleteButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(doneButton.snp.leading).inset(-10)
            $0.size.equalTo(CGSize(width: 70, height: 40))
        }
    }
    
    public func update(title: String) {
        titleLabel.text = title
    }
    
    public func updateIsDeleteMode(isDeleteMode : Bool) {
        self.isDeleteMode = isDeleteMode
    }
}


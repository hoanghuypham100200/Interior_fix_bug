

import Foundation
import RxSwift
import SnapKit
import UIKit

class ButtonEditListView: UIView {
    private lazy var containerView = UIView()
   
    public lazy var showButton = UIButton()
    public lazy var editMarkButton = ChooseButton()
    public lazy var saveButton = ChooseButton()

    

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
     
        editMarkButton.baseSetup(color: AppColor.text_black_patriona, title: "Edit Mark", icon: "paintbrush.fill", weight:.semibold, textSize: 14)
        
        saveButton.baseSetup(color: AppColor.text_black_patriona, title: "Save", icon: "square.and.arrow.down", weight:.semibold, textSize: 14)
        
        showButton.setImage(R.image.icon_show(), for: .normal)
        showButton.backgroundColor = .black
        showButton.layer.cornerRadius = 15
        showButton.clipsToBounds = true

    }
    
    private func setupConstraints() {
        addSubview(containerView)
        containerView.addSubview(showButton)
        containerView.addSubview(editMarkButton)
        containerView.addSubview(saveButton)
        
        containerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16.scaleX)
            $0.top.bottom.equalToSuperview()
        }
        
        showButton.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
            $0.size.equalTo(CGSize(width: 60.scaleX, height: 60.scaleX))
        }
        
        editMarkButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(showButton.snp.trailing).inset(-10.scaleX)
            $0.size.equalTo(CGSize(width: 105.scaleX, height: 60.scaleX))
        }
        
        saveButton.snp.makeConstraints {
            $0.trailing.top.equalToSuperview()
            $0.size.equalTo(CGSize(width: 100.scaleX, height: 60.scaleX))
        }
        
    }
    
}

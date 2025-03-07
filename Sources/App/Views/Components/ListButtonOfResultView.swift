import Foundation
import UIKit
import SnapKit

class ListButtonOfResultView: UIView {

    public lazy var shareButton = ChooseButton()
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
      
        shareButton.baseSetup(color: AppColor.text_black_patriona, title: "Share", icon: "point.3.filled.connected.trianglepath.dotted", weight:.regular, textSize: 18)
        
        saveButton.baseSetup(color: AppColor.text_black_patriona, title: "Save", icon: "square.and.arrow.down.fill", weight:.regular, textSize: 18)
        
    }
    
    private func setupConstraints() {
        
        addSubview(saveButton)
        addSubview(shareButton)
        
        
        saveButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.size.equalTo(CGSize(width: 173.scaleX, height: 55.scaleX))
        }
        
        shareButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.size.equalTo(CGSize(width: 173.scaleX, height: 55.scaleX))
        }
        
    }
    
}



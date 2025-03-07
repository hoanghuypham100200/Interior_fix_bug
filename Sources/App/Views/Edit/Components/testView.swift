

import Foundation
import RxSwift
import SnapKit
import UIKit

class test: UIView {

    
    private lazy var brushSizeView = UIView()
    private lazy var brushSizeLabel = UILabel()
    public lazy var brushSlider = UISlider()
    
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
     
        brushSizeView.backgroundColor = AppColor.bg_ds
        brushSizeView.layer.cornerRadius = 15
        
        brushSizeLabel.text = "Brush size"
        brushSizeLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
        
        brushSlider.minimumValue = 0  // Giá trị nhỏ nhất
        brushSlider.maximumValue = 100  // Giá trị lớn nhất
        brushSlider.value = 50
        brushSlider.minimumTrackTintColor = AppColor.guRed
        brushSlider.maximumTrackTintColor = AppColor.guLine2
        brushSlider.isUserInteractionEnabled = true


    }
   
    private func setupConstraints() {
        addSubview(brushSizeView)
        brushSizeView.addSubview(brushSizeLabel)
        brushSizeView.addSubview(brushSlider)
        
      
        
        brushSizeView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            
        }
        
        brushSizeLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview().inset(10.scaleX)
        }
        
        brushSlider.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10.scaleX)
            $0.top.equalTo(brushSizeLabel.snp.bottom)
            $0.width.equalTo(250)  // Increase width
            $0.height.equalTo(40)
        }
        
    }
    
}

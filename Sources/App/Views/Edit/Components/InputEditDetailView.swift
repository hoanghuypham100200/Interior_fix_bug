

import Foundation
import RxSwift
import SnapKit
import UIKit

class InputEditDetailView: UIView {
    private lazy var containerView = UIView()
    private lazy var titleLabel = UILabel()
    
    public lazy var brushButton = UIButton()
    private lazy var brushIconImage = UIImageView()
    private lazy var brushLabel = UILabel()
    
    public lazy var eraserButton = UIButton()
    private lazy var eraserIconImage = UIImageView()
    private lazy var eraserLabel = UILabel()
    
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
     
        titleLabel.text = "Draw Mask"
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        
        brushButton.layer.cornerRadius = 15
        brushButton.backgroundColor = AppColor.bg_ds
       
        brushLabel.text = "Brush"
        brushLabel.textColor = .black
        brushLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
        brushIconImage.image = UIImage(systemName: "paintbrush.pointed.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold))
        brushIconImage.tintColor = .black

        
        eraserButton.layer.cornerRadius = 15
        eraserButton.backgroundColor = AppColor.bg_ds
        
        eraserLabel.text = "Eraser"
        eraserLabel.textColor = .black
        eraserLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
        eraserIconImage.image = UIImage(systemName: "eraser.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold))
        eraserIconImage.tintColor = .black
        
        brushSizeView.backgroundColor = AppColor.bg_ds
        brushSizeView.layer.cornerRadius = 15
        
        brushSizeLabel.text = "Brush size"
        brushSizeLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
        
        brushSlider.minimumValue = 0  // Giá trị nhỏ nhất
        brushSlider.maximumValue = 30  // Giá trị lớn nhất
        brushSlider.value = Float(EditViewController.brushWidth)
        brushSlider.minimumTrackTintColor = AppColor.guRed
        brushSlider.maximumTrackTintColor = AppColor.guLine2
        brushSlider.isUserInteractionEnabled = true
        brushSlider.setThumbImage(R.image.icon_thumb_slider(), for: .normal)


    }
   
    private func setupConstraints() {
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(brushButton)
        containerView.addSubview(eraserButton)
        containerView.addSubview(brushSizeView)
        
        brushButton.addSubview(brushIconImage)
        brushButton.addSubview(brushLabel)
        eraserButton.addSubview(eraserLabel)
        eraserButton.addSubview(eraserIconImage)
        
        brushSizeView.addSubview(brushSizeLabel)
        brushSizeView.addSubview(brushSlider)
        
        containerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16.scaleX)
            $0.top.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        brushButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).inset(-15.scaleX)
            $0.leading.equalToSuperview()
            $0.size.equalTo(CGSize(width: 120.scaleX, height: 60.scaleX))
        }
        
        brushIconImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(10.scaleX)
        }
        
        brushLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(brushIconImage.snp.bottom).inset(-5.scaleX)
        }
        
        
        eraserButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).inset(-15.scaleX)
            $0.leading.equalTo(brushButton.snp.trailing).inset(-10.scaleX)
            $0.size.equalTo(CGSize(width: 120, height: 60))
        }
        
        eraserIconImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(10.scaleX)
        }
        
        eraserLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(eraserIconImage.snp.bottom).inset(-5.scaleX)
        }
        
        brushSizeView.snp.makeConstraints {
            $0.top.equalTo(eraserButton.snp.bottom).inset(-5.scaleX)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(62.scaleX)
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
    
    func configButtonIsEraserMode(isEraserMode: Bool) {
        if(isEraserMode) {
            eraserLabel.textColor = .white
            eraserButton.backgroundColor = AppColor.guRed
            eraserIconImage.tintColor = .white
            
            brushLabel.textColor = .black
            brushButton.backgroundColor = AppColor.bg_ds
            brushIconImage.tintColor = .black

        } else {
            eraserLabel.textColor = .black
            eraserButton.backgroundColor = AppColor.bg_ds
            eraserIconImage.tintColor = .black
            
            brushLabel.textColor = .white
            brushButton.backgroundColor = AppColor.guRed
            brushIconImage.tintColor = .white
        }
    }
    
}

import Foundation
import RxSwift
import SnapKit
import UIKit

class ChooseThumbView: UIView {
    private lazy var bgImageView = UIImageView()
    public lazy var  button = UIButton()
    
    private lazy var bottomView = UIView()
    private lazy var titleLabel = UILabel()
    private lazy var listButtonView = UIView()
    public lazy var cameraButton = ChooseButton()
    public lazy var photosButton = ChooseButton()
    
    private lazy var thumbframe = UIView()
    public lazy var thumbImageView = UIImageView()
    public lazy var deleteButton = UIButton()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        bgImageView.image = R.image.bg_choose_thumb()
        bgImageView.contentMode = .scaleAspectFit
        
        let textTop = NSMutableAttributedString(string: "Select or take a photo of your room.\nChoose the room type and the desired style.\nTap ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular), NSAttributedString.Key.foregroundColor: AppColor.text_black_patriona])
        let textCenter = NSMutableAttributedString(string: "‘Design’", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .semibold), NSAttributedString.Key.foregroundColor: AppColor.text_black_patriona])
        let textBottom = NSMutableAttributedString(string: " to view result!", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular), NSAttributedString.Key.foregroundColor: AppColor.text_black_patriona])
        textTop.append(textCenter)
        textTop.append(textBottom)
        titleLabel.numberOfLines = 3
        titleLabel.attributedText = textTop
        titleLabel.textAlignment = .center
        
        cameraButton.baseSetup(color: AppColor.text_black_patriona, title: "Camera", icon: "camera.fill", weight:.regular)
        
        photosButton.baseSetup(color: AppColor.text_black_patriona, title: "Photos", icon: "photo.fill", weight:.regular)
        
        thumbframe.backgroundColor = AppColor.bg_1
        thumbImageView.backgroundColor = AppColor.text_black.withAlphaComponent(0.75)
        thumbImageView.contentMode = .scaleAspectFit
        thumbImageView.clipsToBounds = true
        
        deleteButton.setImage(R.image.img_circle_close(), for: .normal)
        deleteButton.imageView?.contentMode = .scaleAspectFit
        
        updateView(hasImage: false)
        
    }
    
    private func setupConstraints() {
        addSubview(bgImageView)
        addSubview(button)
        addSubview(bottomView)
        addSubview(titleLabel)
        bottomView.addSubview(listButtonView)
        listButtonView.addSubview(cameraButton)
        listButtonView.addSubview(photosButton)
        
        addSubview(thumbframe)
        thumbframe.addSubview(thumbImageView)
        thumbframe.addSubview(deleteButton)
        
        bgImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        bottomView.snp.makeConstraints {
            $0.height.equalTo(58.scaleX)
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(listButtonView.snp.top).inset(-20.scaleX)
        }
        
        listButtonView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(8.scaleX)
            $0.height.equalTo(50.scaleX)
        }
        
        cameraButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.size.equalTo(CGSize(width: 120.scaleX, height: 50.scaleX))
        }
        
        photosButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.leading.equalTo(cameraButton.snp.trailing).inset(-15.scaleX)
            $0.size.equalTo(CGSize(width: 120.scaleX, height: 50.scaleX))
        }
        
        thumbframe.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        thumbImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(9.scaleX)
            $0.top.equalToSuperview().inset(10.scaleX)
            $0.size.equalTo(CGSize(width: 40.scaleX, height: 40.scaleX))
        }
    }
    
    public func updateView(hasImage: Bool) {
        thumbframe.isHidden = !hasImage
        
        
        guard !hasImage else {
            return
        }
        thumbImageView.image = nil
    }
}

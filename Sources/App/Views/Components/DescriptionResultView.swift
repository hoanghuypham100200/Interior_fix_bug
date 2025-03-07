import Foundation
import UIKit
import SnapKit

class DescriptionResultView: UIView {
    private lazy var iconTitleImageView = UIImageView()
    private lazy var titleLabel = UILabel()
    public lazy var changeThumbButton = UIButton()
    
    private lazy var iconInputImageView = UIImageView()
    private lazy var titleInputLabel = UILabel()
    private lazy var promptTextLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        iconTitleImageView.image = R.image.icon_magic_result()
        iconTitleImageView.contentMode = .scaleAspectFit
        
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = AppColor.text_black
        
        changeThumbButton.backgroundColor = AppColor.bg_gray_button
        changeThumbButton.layer.cornerRadius = 20.scaleX
        changeThumbButton.setSystemIcon("rectangle.righthalf.filled", pointSize: 20,weight: .medium)
        
        iconInputImageView.setIconSystem(name: "square.and.pencil", color: AppColor.yellow_dark, weight: .medium)
        iconInputImageView.contentMode = .scaleAspectFit
        
        titleInputLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleInputLabel.setText(text: "Your Input", color: AppColor.text_black)
        
        promptTextLabel.font = .systemFont(ofSize: 16, weight: .regular)
        promptTextLabel.textColor = AppColor.text_black
        promptTextLabel.numberOfLines = 0
    }
    
    private func setupConstraints() {
        addSubview(iconTitleImageView)
        addSubview(titleLabel)
        addSubview(changeThumbButton)
        addSubview(iconInputImageView)
        addSubview(titleInputLabel)
        addSubview(promptTextLabel)
        
        iconTitleImageView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.size.equalTo(CGSize(width: 20.scaleX, height: 19.scaleX))
            $0.centerY.equalTo(changeThumbButton)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(iconTitleImageView.snp.trailing).inset(-5.scaleX)
            $0.centerY.equalTo(changeThumbButton)
        }
        
        changeThumbButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.size.equalTo(CGSize(width: 40.scaleX, height: 40.scaleX))
        }
        
        iconInputImageView.snp.makeConstraints {
            $0.top.equalTo(changeThumbButton.snp.bottom).inset(-15.scaleX)
            $0.leading.equalToSuperview()
            $0.size.equalTo(CGSize(width: 20.scaleX, height: 19.scaleX))
        }
        
        titleInputLabel.snp.makeConstraints {
            $0.leading.equalTo(iconInputImageView.snp.trailing).inset(-5.scaleX)
            $0.centerY.equalTo(iconInputImageView)
        }
        
        promptTextLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(iconInputImageView.snp.bottom).inset(-10.scaleX)
            $0.bottom.equalToSuperview()
        }
    }
    
    func updateData(artwork: ArtworkModel) {
        titleLabel.text = "\(artwork.room) - \(artwork.style)"
        promptTextLabel.text = artwork.prompt.trimmingCharacters(in: .whitespaces) == "" ? "None" : artwork.prompt
    }
    
}



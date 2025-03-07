
import Foundation
import SnapKit
import UIKit
import GrowingTextView

class InputPromptView: UIView {
    private lazy var iconImageView = UIImageView()
    private lazy var titleLabel = UILabel()
    public lazy var promptTextView = GrowingTextView()
    
    let userDefault = UserDefaultService.shared
    
    var listRatio:[RatioConfigModel] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        iconImageView.setIconSystem(name: "square.and.pencil", color: AppColor.yellow_dark, weight: .regular)
        
        let textTop = NSMutableAttributedString(string: "Your Input ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .semibold), NSAttributedString.Key.foregroundColor: AppColor.text_black])
        let textCenter = NSMutableAttributedString(string: "(Optional)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .semibold), NSAttributedString.Key.foregroundColor: AppColor.text_gray_2])
        
        textTop.append(textCenter)
        titleLabel.attributedText = textTop
        promptTextView.setupMainPrompt(placeholder: "Type anything you want to have for the room")
        
    }
    
    private func setupConstraints() {
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(promptTextView)
        
        iconImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16.scaleX)
            $0.top.equalToSuperview()
            $0.size.equalTo(CGSize(width: 20.scaleX, height: 19.scaleX))
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(iconImageView.snp.trailing).inset(-5.scaleX)
            $0.centerY.equalTo(iconImageView)
        }
        
        promptTextView.snp.makeConstraints {
            $0.top.equalTo(iconImageView.snp.bottom).inset(-15.scaleX)
            $0.leading.trailing.equalToSuperview().inset(16.scaleX)
            $0.height.equalTo(112.scaleX)
        }
        
    }
   
}

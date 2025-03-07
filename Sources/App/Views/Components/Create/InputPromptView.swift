
import Foundation
import SnapKit
import UIKit
import GrowingTextView

class InputPromptView: UIView {
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
        
        let textTop = NSMutableAttributedString(string: "Your Input ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .semibold), NSAttributedString.Key.foregroundColor: AppColor.text_black])
        let textCenter = NSMutableAttributedString(string: "(Optional)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .semibold), NSAttributedString.Key.foregroundColor: AppColor.text_gray_2])
        
        textTop.append(textCenter)
        titleLabel.attributedText = textTop
        promptTextView.setupMainPrompt(placeholder: "Type anything you want to have for the room")
        
    }
    
    private func setupConstraints() {
        addSubview(titleLabel)
        addSubview(promptTextView)
        
     
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16.scaleX)
            $0.top.equalToSuperview()
        }
        
        promptTextView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).inset(-15.scaleX)
            $0.leading.trailing.equalToSuperview().inset(16.scaleX)
            $0.height.equalTo(112.scaleX)
        }
        
    }
   
}

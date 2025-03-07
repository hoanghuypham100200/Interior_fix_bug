
import Foundation
import SnapKit
import UIKit
import GrowingTextView

class InputEditPromptView: UIView {
    public lazy var genButton = UIButton()
    public lazy var promptTextView = GrowingTextView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        
        genButton.setImage(UIImage(systemName: "paintbrush.pointed.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold)),  for: .normal)
        genButton.tintColor = AppColor.guRed
        genButton.layer.cornerRadius = 27
        genButton.backgroundColor = AppColor.bg_ds
        
        promptTextView.setupEditPrompt(placeholder: "Type what you want to change")
        
    }
    
    private func setupConstraints() {
        addSubview(genButton)
        addSubview(promptTextView)
        
        
        promptTextView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(16.scaleX)
            $0.trailing.equalTo(genButton.snp.leading).inset(-12.scaleX)
            $0.height.equalTo(112.scaleX)
        }
        
        genButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(10)
            $0.trailing.equalToSuperview().inset(16.scaleX)
            $0.size.equalTo(CGSize(width: 55.scaleX, height: 55.scaleX))
        }
        
    }

   
}



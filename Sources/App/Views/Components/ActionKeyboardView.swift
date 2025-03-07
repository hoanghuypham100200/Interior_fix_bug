import SnapKit
import UIKit

class ActionKeyboardView: UIView {
    public lazy var placeHolderLabel = UILabel()
    public lazy var doneButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        self.backgroundColor = AppColor.bg_1
        
        placeHolderLabel.textColor = AppColor.text_2
        placeHolderLabel.font = .systemFont(ofSize: 14)
        
        let doneAttribue = NSMutableAttributedString(string: "Done", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .bold), NSAttributedString.Key.foregroundColor: AppColor.text_black])
        doneButton.setAttributedTitle(doneAttribue, for: .normal)
        doneButton.backgroundColor = AppColor.bg_2
        doneButton.cornerRadius = 12.scaleX
        doneButton.clipsToBounds = true
    }
    
    private func setupConstraints() {
        addSubview(placeHolderLabel)
        addSubview(doneButton)
        
        placeHolderLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16.scaleX)
            $0.trailing.lessThanOrEqualTo(doneButton.snp.leading).inset(-10.scaleX)
        }
        
        doneButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(5.scaleX)
            $0.trailing.equalToSuperview().inset(16.scaleX)
            $0.size.equalTo(CGSize(width: 92.scaleX, height: 40.scaleX))
        }
    }
    
    public func updatePlaceHolder(placeHolder: String = "Type anything...") {
        placeHolderLabel.text = placeHolder
    }
}

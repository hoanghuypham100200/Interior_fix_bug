import Foundation
import GrowingTextView
import UIKit

extension GrowingTextView {
    
    func setupMainPrompt(placeholder: String) {
        self.placeholder = placeholder
        self.placeholderColor = AppColor.text_placeholder
        self.textColor = AppColor.text_gt
        self.maxHeight = 112.scaleX
        self.minHeight = 112.scaleX
        self.backgroundColor = AppColor.bg_input
        self.layer.cornerRadius = 15.scaleX
        self.font = .systemFont(ofSize: 14)
        self.textContainerInset = UIEdgeInsets(top: 10.scaleX, left: 10.scaleX, bottom: 10.scaleX, right: 10.scaleX)
    }
}

class CustomGrowingTextView: GrowingTextView {
    
    private let placeholderLabel = UILabel()
    
    override var text: String! {
        didSet {
            placeholderLabel.isHidden = !text.isEmpty
        }
    }
    
    override var attributedText: NSAttributedString! {
        didSet {
            placeholderLabel.isHidden = !attributedText.string.isEmpty
        }
    }
    
    override var font: UIFont? {
        didSet {
            if let font = font {
                placeholderLabel.font = font
            }
        }
    }
    
    override var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder
        }
    }
    
    var placeholderFont: UIFont? {
        didSet {
            if let placeholderFont = placeholderFont {
                placeholderLabel.font = placeholderFont
            }
        }
    }
    
//    override var placeholderColor: UIColor? {
//        didSet {
//            if let placeholderColor = placeholderColor {
//                placeholderLabel.textColor = placeholderColor
//            }
//        }
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupPlaceholder()
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupPlaceholder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupPlaceholder()
    }
    
    private func setupPlaceholder() {
        placeholderLabel.font = self.font
        placeholderLabel.textColor = .lightGray
        placeholderLabel.numberOfLines = 0
        placeholderLabel.textAlignment = .left
        addSubview(placeholderLabel)
        
        placeholderLabel.snp.makeConstraints { make in
            make.leading.equalTo(self).offset(textContainerInset.left + textContainer.lineFragmentPadding)
            make.trailing.equalTo(self).offset(-(textContainerInset.right + textContainer.lineFragmentPadding))
            make.top.equalTo(self).offset(textContainerInset.top)
            make.bottom.lessThanOrEqualTo(self).offset(-textContainerInset.bottom)
        }
    }
}

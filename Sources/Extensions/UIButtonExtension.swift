import Foundation
import UIKit

extension UIButton {

    func setupMainButton(text: String, textColor: UIColor, textSize: CGFloat, textWeight: UIFont.Weight, icon: UIImage? = nil, iconColor: UIColor, bgColor: UIColor, corner: Int, padding: CGFloat, hideIcon: Bool = false) {
        let tintedImage = icon?.withRenderingMode(.alwaysTemplate)
        let attribute = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: textSize, weight: textWeight), NSAttributedString.Key.foregroundColor: textColor])
        self.tintColor = iconColor
        self.imageView?.contentMode = .scaleAspectFit
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: hideIcon ? 0 : (padding + 5), bottom: 0, right: 0)
        self.setAttributedTitle(attribute, for: .normal)
        self.setImage(hideIcon ? nil : tintedImage, for: .normal)
        self.backgroundColor = bgColor
        self.clipsToBounds = true
        self.semanticContentAttribute = UIApplication.shared.userInterfaceLayoutDirection == .leftToRight ? .forceRightToLeft : .forceLeftToRight
        self.cornerRadius = corner.scaleX
    }
    
    func setupTextIconButton(text: String, textColor: UIColor, textSize: CGFloat, textWeight: UIFont.Weight, icon: UIImage?, iconColor: UIColor, bgColor: UIColor, corner: Int, padding: CGFloat) {
        let tintedImage = icon?.withRenderingMode(.alwaysTemplate)
        let attribute = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: textSize, weight: textWeight), NSAttributedString.Key.foregroundColor: textColor])
        self.tintColor = iconColor
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -padding)
        self.setAttributedTitle(attribute, for: .normal)
        self.setImage(tintedImage, for: .normal)
        self.backgroundColor = bgColor
        self.clipsToBounds = true
        self.semanticContentAttribute = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ? .forceRightToLeft : .forceLeftToRight
        self.cornerRadius = corner.scaleX
    }
    
    func setupContinueButton(title: String, fontWeight: UIFont.Weight = .medium, titleColor: UIColor = AppColor.text_black, bgColor: UIColor = AppColor.text_black) {
        let titleAttribue = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: fontWeight), NSAttributedString.Key.foregroundColor: titleColor])
        self.setAttributedTitle(titleAttribue, for: .normal)
        self.cornerRadius = 15.scaleX
        self.clipsToBounds = true
        self.backgroundColor = bgColor
    }
    
    func setupPremiumButton() {
        let titleAttribue = NSMutableAttributedString(string: "Pro", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .semibold), NSAttributedString.Key.foregroundColor: AppColor.text_black])
        self.setAttributedTitle(titleAttribue, for: .normal)
        self.cornerRadius = 20.scaleX
        self.clipsToBounds = true
        self.setImage(R.image.icon_premium(), for: .normal)
        self.semanticContentAttribute = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ? .forceRightToLeft : .forceLeftToRight
        var configuration = UIButton.Configuration.filled()
        configuration.imagePadding = 5.scaleX
        configuration.baseBackgroundColor = AppColor.premium
        configuration.contentInsets = .zero
        self.configuration = configuration
    }
    
    func setupImageButton(icon: UIImage?, iconColor: UIColor, bgColor: UIColor, corner: Int) {
        let tintedImage = icon?.withRenderingMode(.alwaysTemplate)
        self.tintColor = iconColor
        self.backgroundColor = bgColor
        self.cornerRadius = corner.scaleX
        self.clipsToBounds = true
        self.setImage(tintedImage, for: .normal)
    }
    
    func setupTextButton(title: String, fontSize: CGFloat, fontWeight: UIFont.Weight, textColor: UIColor, bgColor: UIColor, corner: Int) {
        let titleAttribue = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: fontWeight), NSAttributedString.Key.foregroundColor: textColor])
        self.setAttributedTitle(titleAttribue, for: .normal)
        self.backgroundColor = bgColor
        self.cornerRadius = corner.scaleX
        self.clipsToBounds = true
    }
    
    // Title button
    func setupTitleButton(title: String, fontWeight: UIFont.Weight, fontSize: Int, titleColor: UIColor, bgColor: UIColor, radius: Int) {
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(fontSize) , weight: fontWeight)
        self.clipsToBounds = true
        self.backgroundColor = bgColor
        self.cornerRadius = radius.scaleX
    }
    
    // Title + icon button
    func setupTitleIconButton(title: String, fontWeight: UIFont.Weight, fontSize: Int, titleColor: UIColor, icon: UIImage?, iconColor: UIColor, padding: Int, bgColor: UIColor, radius: Int) {
        let titleAttribue = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: CGFloat(fontSize), weight: fontWeight), NSAttributedString.Key.foregroundColor: titleColor])
        self.setAttributedTitle(titleAttribue, for: .normal)
        self.cornerRadius = radius.scaleX
        self.clipsToBounds = true
        self.tintColor = iconColor
        self.setImage(icon, for: .normal)
        self.semanticContentAttribute = UIApplication.shared.userInterfaceLayoutDirection == .leftToRight ? .forceRightToLeft : .forceLeftToRight
        self.backgroundColor = bgColor
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: padding.scaleX)
    }
    
    func setupContinueButton() {
        self.cornerRadius = 20.scaleX
        self.setTitle("CONTINUE", for: .normal)
        self.setTitleColor(AppColor.text_black, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        self.backgroundColor = AppColor.yellow_normal_hover
    }
    
    func setupBaseButton(title: String, icon: UIImage?, textColor:  UIColor , backgroundColor: UIColor, radius: Int, font: UIFont) {
        let attribute = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: textColor])
        
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10.scaleX, bottom: 0, right: 0)
        self.setAttributedTitle(attribute, for: .normal)
        self.imageView?.contentMode = .scaleAspectFit
        self.setImage(icon, for: .normal)
        self.clipsToBounds = true
        self.backgroundColor = backgroundColor
        self.cornerRadius = radius.scaleX
    }
    
    func cancelRequestButton() {
        // Create an attributed string with underline
        let allStyle = NSMutableAttributedString(
            string: "Cancel request",
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .semibold),
                NSAttributedString.Key.foregroundColor: AppColor.bg_1,
                NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
            ]
        )

        // Set the attributed title to the button
        self.setAttributedTitle(allStyle, for: .normal)
    }
    
    func setSystemIcon(_ systemName: String, pointSize: CGFloat, weight: UIImage.SymbolWeight = .regular, tintColor: UIColor = .black) {
           let config = UIImage.SymbolConfiguration(pointSize: pointSize, weight: weight)
           if let image = UIImage(systemName: systemName, withConfiguration: config) {
               self.setImage(image, for: .normal)
               self.tintColor = tintColor
           }
       }
}

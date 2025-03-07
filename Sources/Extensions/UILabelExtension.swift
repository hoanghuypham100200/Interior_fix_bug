import Foundation
import UIKit

extension UILabel {
    
    public func updateGradientTextColor() {
        let gradientColors = [AppColor.premium, AppColor.premium]
        let size = CGSize(width: intrinsicContentSize.width, height: 1)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        var  colors : [CGColor] = []
        for color in gradientColors {
            colors.append(color.cgColor)
        }
        guard let gradient = CGGradient(
            colorsSpace: CGColorSpaceCreateDeviceRGB(),
            colors: colors as CFArray,
            locations: nil
        ) else { return }
        
        context.drawLinearGradient(
            gradient,
            start: CGPoint.zero,
            end: CGPoint(x: size.width, y: 0), // Horizontal gradient
            options: []
        )
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            self.textColor = UIColor(patternImage: image)
        }
    }
    
    func animate(newText: String, interval: TimeInterval = 0.1, delay: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left
            var pause: TimeInterval = 0
            self.text = ""
            var charIndex = 0.0
            for letter in newText {
                Timer.scheduledTimer(withTimeInterval: interval * charIndex + pause, repeats: false) { (_) in
                    self.text?.append(letter)
                    let attributedString = NSMutableAttributedString(string: self.text ?? "")
                    attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
                    attributedString.addAttribute(NSAttributedString.Key.kern, value: 1.0, range: NSRange(location: 0, length: attributedString.length - 1))
                    self.attributedText = attributedString
                }
                charIndex += 0.3
                if(letter == "," || letter == ".") {
                    pause += 0.1
                }
            }
        }
    }
    
    public func setTyping(text: String, characterDelay: TimeInterval = 4.0, completion: @escaping (Bool) -> ()) {
        let writingTask = DispatchWorkItem { [weak self] in
            text.forEach { char in
                DispatchQueue.main.async {
                    self?.text?.append(char)
//                    self?.updateGradientTextColor()
                }
                Thread.sleep(forTimeInterval: characterDelay/100)
            }
            completion(true)
        }
        let queue: DispatchQueue = .init(label: "typespeed", qos: .userInteractive)
        queue.asyncAfter(deadline: .now() + 0.05, execute: writingTask)
    }
    
    public func setText(text: String, color: UIColor) {
        self.text = text
        self.textColor = color
    }
    
    public func applyShadow() {
        self.shadowColor = .black.withAlphaComponent(0.25)
        self.shadowOffset = CGSize(width: 2.5, height: 2.5)
    }
}


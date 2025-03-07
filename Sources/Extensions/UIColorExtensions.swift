//
//  UIColor.swift
//  App
//
//  Created by Nam Nguyen on 2/4/20.
//  Copyright © 2020 Awesome Guys. All rights reserved.
//

import Foundation

import UIKit

extension UIColor {
    static var customBlack: UIColor {
        return .color(from: "111111")
    }
    
    static var darkMain: UIColor {
        return .color(from: "0d463d")
    }
    
    static var customGray: UIColor {
        return .init(white: 0.7, alpha: 1)
    }
    
    static var customDarkGray: UIColor {
        return .init(white: 0.12, alpha: 1)
    }
    
    static var customBG: UIColor {
        return .color(from: "edeff1")
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, editAlpha: CGFloat) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: editAlpha)
    }
    
    convenience init(rgb: Int, alpha: CGFloat = 1) {
        self.init(red: (rgb >> 16) & 0xff,
                  green: (rgb >> 8) & 0xff,
                  blue: rgb & 0xff,
                  editAlpha: alpha)
    }
    
    static func color(from hexString: String) -> UIColor {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        return UIColor.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return String(format:"#%06x", rgb)
    }
    
}

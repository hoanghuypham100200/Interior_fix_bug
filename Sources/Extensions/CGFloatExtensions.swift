//
//  CGFloat.swift
//  WatchKeyboard
//
//  Created by Duy Cao on 3/19/20.
//  Copyright © 2020 Awesome Guys. All rights reserved.
//

import Foundation
import UIKit

extension Double {
    func cgFloat() -> CGFloat {
        return CGFloat(self)
    }
}

extension CGFloat {
    static func standardScreenWidth() -> CGFloat {
        return 393.0
    }

    static func standardScreenHeight() -> CGFloat {
        return 812.0
    }

    static func screenWidth() -> CGFloat {
        return UIScreen.main.bounds.size.width
    }

    static func screenHeight() -> CGFloat {
        return UIScreen.main.bounds.size.height
    }

    func scaleY() -> CGFloat {
        return self.scale(ratio: CGFloat.screenHeight() / CGFloat.standardScreenHeight())
    }
    
    func scaleX() -> CGFloat {
        return self.scale(ratio: CGFloat.screenWidth() / CGFloat.standardScreenWidth())
    }

    func scale(ratio: CGFloat) -> CGFloat {
        return self * ratio
    }

    static var sidePadding: CGFloat {
        return 20.scaleX
    }
}

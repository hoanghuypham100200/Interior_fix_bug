//
//  Int+Extension.swift
//  FanNoise
//
//  Created by Nam Nguyen on 4/18/20.
//  Copyright © 2020 Awesome Guys. All rights reserved.
//

import Foundation
import UIKit

extension Int {
    func toTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "mm:ss"
        return formatter.string(from: Date(timeIntervalSinceReferenceDate: TimeInterval(self)))
    }
    
    func timeString(time: Int) -> String {
        let hours = Int(time) / 3600
        let minutes = (Int(time) % 3600) / 60
        let seconds = (Int(time) % 3600) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

extension Int {
    var scaleY: CGFloat {
        return self.toCGFloat.scaleY()
    }
    
    var scaleX: CGFloat {
        return self.toCGFloat.scaleX()
    }
    
    var toCGFloat: CGFloat {
        return CGFloat(self)
    }
}

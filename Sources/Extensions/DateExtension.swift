//
//  Date+Extension.swift
//  FanNoise
//
//  Created by Nam Nguyen on 4/21/20.
//  Copyright © 2020 Awesome Guys. All rights reserved.
//

import Foundation

extension Date {
    static func localDate() -> Date {
        let dateFormat = "yyyy-MM-dd HH:mm:ss"
        let now = Date()
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = dateFormat
        return formatter.date(from: now.toCurrentLocal(format: dateFormat)) ?? Date()
    }

    func toCurrentLocal(format: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

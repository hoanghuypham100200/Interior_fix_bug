//
//  DalleConfigModel.swift
//  AnimeDiffusionApp
//
//  Created by thainam on 10/04/2023.
//  Copyright © 2023 Vulcan Labs. All rights reserved.
//

import Foundation

struct DalleConfigModel: Codable {
    var isFreeCreate: Bool
    var countUsage: Int
    var lastDateUse: Int
}

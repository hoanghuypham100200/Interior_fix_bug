//
//  StyleConfigModel.swift
//  AIInteriorRoomApp
//
//  Created by admin on 11/9/24.
//  Copyright © 2024 Vulcan Labs. All rights reserved.
//

import Foundation

struct StyleConfigModel: Codable {
    let id: String
    let modelID: String
    let name: String
    var prompt: String
    let thumbUrl: String
    let isPremium: Bool
}


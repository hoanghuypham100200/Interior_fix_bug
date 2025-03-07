//
//  DailyUsageLimitModel.swift
//  AIInteriorRoomApp
//
//  Created by Huy on 4/3/25.
//  Copyright © 2025 Vulcan Labs. All rights reserved.
//

import Foundation

struct DailyUsageLimitModel: Codable {
    let free_usage: FreeUsage
    let daily_limit: DailyLimit
    
}

struct FreeUsage: Codable {
    let create: Int
}

struct DailyLimit: Codable {
    let create: Int
    let edit: Int
}

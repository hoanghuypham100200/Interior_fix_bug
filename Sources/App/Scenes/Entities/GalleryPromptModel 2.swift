//
//  HistoryPromptModel.swift
//  AnimeDiffusionApp
//
//  Created by thainam on 18/04/2023.
//  Copyright © 2023 Vulcan Labs. All rights reserved.
//

import Foundation

struct GalleryPromptModel: Codable {
    let id: String
    let style: String
    let prompt: String
    let ratio: String
}

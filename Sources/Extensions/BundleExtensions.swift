//
//  Bundle+Extensions.swift
//  WatchRecorder
//
//  Created by Mai Ho on 2/20/20.
//  Copyright © 2020 Vulcan. All rights reserved.
//

import Foundation

extension Bundle {
    var releaseVersionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? "0"
    }

    var buildVersionNumber: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? "0"
    }
}

//
//  SettingStoreViewController.swift
//  WatchKeyboard
//
//  Created by Duy Cao on 3/25/20.
//  Copyright © 2020 Vulcan Labs. All rights reserved.
//

import Foundation
import UIKit

class SettingStoreViewController: BaseViewController, StoryboardLoadable {
    // MARK: Properties

    var presenter: SettingStorePresentation?

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension SettingStoreViewController: SettingStoreView {
    // TODO: implement view output methods
}

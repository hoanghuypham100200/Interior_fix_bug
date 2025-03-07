//
//  SettingStoreRouter.swift
//  WatchKeyboard
//
//  Created by Duy Cao on 3/25/20.
//  Copyright © 2020 Vulcan Labs. All rights reserved.
//

import Foundation
import UIKit

class SettingStoreRouter {
    // MARK: Properties

    weak var view: UIViewController?

    // MARK: Static methods

    static func setupModule() -> SettingStoreViewController {
        let viewController = UIStoryboard.loadViewController() as SettingStoreViewController
        let presenter = SettingStorePresenter()
        let router = SettingStoreRouter()
        let interactor = SettingStoreInteractor()

        viewController.presenter = presenter

        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor

        router.view = viewController

        interactor.output = presenter

        return viewController
    }
}

extension SettingStoreRouter: SettingStoreWireframe {
    // TODO: Implement wireframe methods
}

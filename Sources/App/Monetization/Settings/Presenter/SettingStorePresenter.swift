//
//  SettingStorePresenter.swift
//  WatchKeyboard
//
//  Created by Duy Cao on 3/25/20.
//  Copyright © 2020 Vulcan Labs. All rights reserved.
//

import Foundation

class SettingStorePresenter {
    // MARK: Properties

    weak var view: SettingStoreView?
    var router: SettingStoreWireframe?
    var interactor: SettingStoreUseCase?
}

extension SettingStorePresenter: SettingStorePresentation {
    // TODO: implement presentation methods
}

extension SettingStorePresenter: SettingStoreInteractorOutput {
    // TODO: implement interactor output methods
}

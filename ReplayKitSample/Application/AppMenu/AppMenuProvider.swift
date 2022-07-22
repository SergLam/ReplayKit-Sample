//
//  AppMenuProvider.swift
//  ReplayKitSample
//
//  Created by Serhii Liamtsev on 7/22/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import Cocoa

final class AppMenuProvider {
    
    // MARK: - Life cycle
    deinit {
        
    }
    
    init() {
        
    }
    
    
    
    private func createAboutAppMenu() -> NSMenu {
        let menu = NSMenu()
        menu.addItem(withTitle: AppConstants.appName, action: #selector(didTapAppNameMenuItem), keyEquivalent: AppMenuKeys.appName.rawValue)
        return menu
    }
    
    // MARK: - Actions
    @objc
    private func didTapAppNameMenuItem() {
        
    }
}

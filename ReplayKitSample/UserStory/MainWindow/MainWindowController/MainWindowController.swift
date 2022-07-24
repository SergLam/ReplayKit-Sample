//
//  MainWindowController.swift
//  ReplayKitSample
//
//  Created by Serhii Liamtsev on 7/23/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import AppKit

final class MainWindowController: NSWindowController {
    
    // MARK: - Life cycle
    deinit {
        
    }
    
    override init(window: NSWindow?) {
        super.init(window: window)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func windowWillLoad() {
        super.windowWillLoad()
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
    }
}

//
//  main.swift
//  ReplayKitSample
//
//  Created by Serhii Liamtsev on 7/25/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import AppKit

// 1
let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate

// 2
_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)

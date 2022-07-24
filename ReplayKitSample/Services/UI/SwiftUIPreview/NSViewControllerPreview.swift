//
//  UIViewControllerPreview.swift
//  GiftWishesiOS
//
//  Created by Serg Liamthev on 07.01.2021.
//  Copyright © 2021 Serg Liamthev. All rights reserved.
//

import SwiftUI
import AppKit

@available(macOS 10.15, *)
struct NSViewControllerPreview: SwiftUI.View {
    
    private let factory: () -> NSViewController
    
    init(factory: @escaping () -> NSViewController) {
        self.factory = factory
    }
    
    var body: some SwiftUI.View {
        Renderer(factory)
    }
    
    private struct Renderer: NSViewControllerRepresentable {
        
        typealias NSViewControllerType = NSViewController
        
        private let factory: () -> NSViewController
        
        init(_ factory: @escaping () -> NSViewController) {
            self.factory = factory
        }
        
        func makeNSViewController(context: Context) -> NSViewController {
            return factory()
        }
        
        func updateNSViewController(_ nsViewController: NSViewControllerType, context: Context) {
            
        }
    }
}

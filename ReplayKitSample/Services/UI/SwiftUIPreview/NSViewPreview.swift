//
//  NSViewPreview.swift
//  ReplayKitSample
//
//  Created by Serg Liamthev on 06.01.2021.
//  Copyright © 2021 Serg Liamthev. All rights reserved.
//

import SwiftUI
import AppKit

@available(macOS 10.15, *)
struct NSViewPreview: SwiftUI.View {
    
    private let factory: () -> NSView
    
    init(factory: @escaping () -> NSView) {
        self.factory = factory
    }
    
    var body: some SwiftUI.View {
        Renderer(factory)
    }
    
    private struct Renderer: NSViewRepresentable {
        
        private let factory: () -> NSView
        
        init(_ factory: @escaping () -> NSView) {
            self.factory = factory
        }
        
        func makeNSView(context: Context) -> NSView {
            return factory()
        }
        
        func updateNSView(_ uiView: NSView, context: Context) {
            
        }
    }
}

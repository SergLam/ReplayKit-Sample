/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The app's delegate object.
*/

import Cocoa

final class AppDelegate: NSObject, NSApplicationDelegate {

    private var window: NSWindow!
    private var mainWindowController: MainWindowController!
    private var mainViewController: MainViewController!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        let rect = NSRect(x: 0, y: 0, width: 480, height: 270)
        let mask: NSWindow.StyleMask = [.miniaturizable, .closable, .resizable, .titled]
        mainViewController = MainViewController(rect: rect)
        window = NSWindow(contentRect:rect, styleMask :mask, backing: .buffered, defer: false)
        window.center()
        window.title = "ReplayKit Sample"
        window.contentViewController = mainViewController
        window.makeKeyAndOrderFront(nil)
        mainWindowController = MainWindowController(window: window)
        mainWindowController.showWindow(nil)
    }
}


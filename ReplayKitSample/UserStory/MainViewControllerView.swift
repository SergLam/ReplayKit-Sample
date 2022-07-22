//
//  MainViewControllerView.swift
//  ReplayKitSample
//
//  Created by Serhii Liamtsev on 7/22/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import Cocoa
import ReplayKit

final class MainViewControllerView: NSView {
    
    private var recordButton: NSButton = NSButton(frame: NSRect.zero)
    private var captureButton: NSButton = NSButton(frame: NSRect.zero)
    private var broadcastButton: NSButton = NSButton(frame: NSRect.zero)
    private var clipButton: NSButton = NSButton(frame: NSRect.zero)
    private var getClipButton: NSButton = NSButton(frame: NSRect.zero)
    
    private var cameraCheckBox: NSButton = NSButton(frame: NSRect.zero)
    private var microphoneCheckBox: NSButton = NSButton(frame: NSRect.zero)
    
    private var cameraView: NSView?
    
    // MARK: - Life cycle
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Public
    
    func setupCameraView() {
        DispatchQueue.main.async {
            // Validate that the camera preview view and camera are in an enabled state.
            if (RPScreenRecorder.shared().cameraPreviewView != nil) && RPScreenRecorder.shared().isCameraEnabled {
                // Set the camera view to the camera preview view of RPScreenRecorder.
                guard let cameraView = RPScreenRecorder.shared().cameraPreviewView else {
                    print("Unable to retrieve the cameraPreviewView from RPScreenRecorder. Returning.")
                    return
                }
                // Set the frame and position to place the camera preview view.
                cameraView.frame = NSRect(x: 0, y: self.frame.size.height - 100, width: 100, height: 100)
                // Ensure that the view is layer-backed.
                cameraView.wantsLayer = true
                // Add the camera view as a subview to the main view.
                self.addSubview(cameraView)
                
                self.cameraView = cameraView
            }
        }
    }
    
    func tearDownCameraView() {
        DispatchQueue.main.async {
            // Remove the camera view from the main view when tearing down the camera.
            self.cameraView?.removeFromSuperview()
        }
    }
    
    // MARK: - Private
    private func setupLayout() {
        
    }
}

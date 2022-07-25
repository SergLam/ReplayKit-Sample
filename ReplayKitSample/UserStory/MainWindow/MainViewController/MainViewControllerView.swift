//
//  MainViewControllerView.swift
//  ReplayKitSample
//
//  Created by Serhii Liamtsev on 7/22/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import AppKit
import ReplayKit

protocol MainViewControllerViewDelegate: AnyObject {
    
    func didTapCameraCheckBoxButton()
    func didTapMicrophoneCheckBox()
    func didTapGetClipButton()
    
    func didTapRecordButton()
    func didTapCaptureButton()
    func didTapBroadcastButton()
    func didTapClipButton()
}

final class MainViewControllerView: NSView {
    
    weak var delegate: MainViewControllerViewDelegate?
    
    private let titleField: NSTextField = NSTextField(labelWithString: "ReplayKit")
    private let titleFieldText: String = "ReplayKit"
    
    private let mainVStack: NSStackView = NSStackView(frame: NSRect.zero)
    private let mainVStackSpacing: CGFloat = 20.0
    
    private let buttonsStackSpacing: CGFloat = 10.0
    
    private let topButtonsStack: NSStackView = NSStackView(frame: NSRect.zero)
    
    private let cameraCheckBox: NSButton = NSButton(frame: NSRect.zero)
    private let cameraCheckBoxTitle: String = "Camera"
    
    private let microphoneCheckBox: NSButton = NSButton(frame: NSRect.zero)
    private let microphoneCheckBoxTitle: String = "Microphone"
    
    private let getClipButtonStack: NSStackView = NSStackView(frame: NSRect.zero)
    private let getClipButton: NSButton = NSButton(frame: NSRect.zero)
    private let getClipButtonTitle: String = "Get clip"
    
    private let bottomButtonsStack: NSStackView = NSStackView(frame: NSRect.zero)
    
    private let recordButton: NSButton = NSButton(frame: NSRect.zero)
    private let recordButtonStartTitle: String = "Start Recording"
    private let recordButtonStopTitle: String = "Stop Recording"
    
    private let captureButton: NSButton = NSButton(frame: NSRect.zero)
    private let captureButtonStartTitle: String = "Start Capture"
    private let captureButtonStopTitle: String = "Stop Capture"
    
    private let broadcastButton: NSButton = NSButton(frame: NSRect.zero)
    private let broadcastButtonStartTitle: String = "Start Broadcast"
    private let broadcastButtonStopTitle: String = "Stop Broadcast"
    
    private let clipButton: NSButton = NSButton(frame: NSRect.zero)
    private let clipButtonStartTitle: String = "Start Clip"
    private let clipButtonStopTitle: String = "Stop Clip"
    
    private var cameraView: NSView?
    
    // MARK: - Life cycle
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Public
    func setupCameraView() {
        // Validate that the camera preview view and camera are in an enabled state.
        if (RPScreenRecorder.shared().cameraPreviewView != nil) && RPScreenRecorder.shared().isCameraEnabled {
            // Set the camera view to the camera preview view of RPScreenRecorder.
            guard let cameraView = RPScreenRecorder.shared().cameraPreviewView else {
                print("Unable to retrieve the cameraPreviewView from RPScreenRecorder. Returning.")
                return
            }
            // Set the frame and position to place the camera preview view.
            cameraView.frame = NSRect(x: 0, y: frame.size.height - 100, width: 100, height: 100)
            // Ensure that the view is layer-backed.
            cameraView.wantsLayer = true
            // Add the camera view as a subview to the main view.
            addSubview(cameraView)
            
            self.cameraView = cameraView
        }
    }
    
    /// Remove the camera view from the main view when tearing down the camera.
    func tearDownCameraView() {
        cameraView?.removeFromSuperview()
    }
    
    func setRecordButtonTitle(isRecording: Bool) {
        recordButton.title = isRecording ? recordButtonStopTitle : recordButtonStartTitle
    }
    
    func setRecordButtonState(isEnabled: Bool) {
        recordButton.isEnabled = isEnabled
    }
    
    func setCaptureButtonTitle(isCapturing: Bool) {
        captureButton.title = isCapturing ? captureButtonStopTitle : captureButtonStartTitle
    }
    
    func setCaptureButtonState(isEnabled: Bool) {
        captureButton.isEnabled = isEnabled
    }
    
    func setBroadcastButtonTitle(isBroadcasting: Bool) {
        broadcastButton.title = isBroadcasting ? broadcastButtonStopTitle : broadcastButtonStartTitle
    }
    
    func setBroadcastButtonState(isEnabled: Bool) {
        broadcastButton.isEnabled = isEnabled
    }
    
    func setClipButtonTitle(isCliping: Bool) {
        clipButton.title = isCliping ? clipButtonStopTitle : clipButtonStartTitle
    }
    
    func setClipButtonState(isEnabled: Bool) {
        clipButton.isEnabled = isEnabled
    }
    
    func getCameraCheckBoxState() -> NSButton.StateValue {
        return cameraCheckBox.state
    }
    
    func getMicrophoneCheckBox() -> NSButton.StateValue {
        return microphoneCheckBox.state
    }
    
    /// Return `getClipButton` state.
    /// - Returns: Bool flag, whether buttons is enabled.
    func getClipButtonState() -> Bool {
        return getClipButton.isEnabled
    }
    
    func setGetClipButtonState(isEnabled: Bool) {
        getClipButton.isEnabled = isEnabled
    }
    
    func setGetClipButtonVisibility(isHidden: Bool) {
        getClipButton.isHidden = isHidden
    }
    
    // MARK: - Private
    private func setupView() {
        setupLayout()
        setupActions()
    }
    
    private func setupActions() {
        cameraCheckBox.action = #selector(didTapCameraCheckBoxButton)
        microphoneCheckBox.action = #selector(didTapMicrophoneCheckBox)
        getClipButton.action = #selector(didTapGetClipButton)
        
        recordButton.action = #selector(didTapRecordButton)
        captureButton.action = #selector(didTapCaptureButton)
        broadcastButton.action = #selector(didTapBroadcastButton)
        clipButton.action = #selector(didTapGetClipButton)
    }
    
    private func setupLayout() {
        
        addSubview(titleField)
        titleField.font = .systemFont(ofSize: 26, weight: .regular)
        
        titleField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleField.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0.8)
        ])
        
        addSubview(mainVStack)
        mainVStack.orientation = .vertical
        mainVStack.alignment = .leading
        mainVStack.distribution = .fill
        mainVStack.spacing = mainVStackSpacing
        
        mainVStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainVStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            mainVStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            mainVStack.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -15)
        ])
        
        mainVStack.addArrangedSubview(topButtonsStack)
        topButtonsStack.orientation = .horizontal
        topButtonsStack.alignment = .width
        topButtonsStack.distribution = .fillEqually
        topButtonsStack.spacing = buttonsStackSpacing
        
        topButtonsStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topButtonsStack.leadingAnchor.constraint(equalTo: mainVStack.leadingAnchor),
            topButtonsStack.trailingAnchor.constraint(equalTo: mainVStack.trailingAnchor)
        ])
        
        topButtonsStack.addArrangedSubview(cameraCheckBox)
        cameraCheckBox.title = cameraCheckBoxTitle
        cameraCheckBox.setButtonType(NSButton.ButtonType.switch)
        
        topButtonsStack.addArrangedSubview(microphoneCheckBox)
        microphoneCheckBox.title = microphoneCheckBoxTitle
        microphoneCheckBox.setButtonType(NSButton.ButtonType.switch)
        
        topButtonsStack.addArrangedSubview(getClipButtonStack)
        getClipButtonStack.orientation = .horizontal
        getClipButtonStack.alignment = .trailing
        getClipButtonStack.distribution = .fill
        getClipButtonStack.spacing = buttonsStackSpacing
        
        getClipButtonStack.addArrangedSubview(getClipButton)
        getClipButton.title = getClipButtonTitle
        getClipButton.bezelStyle = .rounded
        
        mainVStack.addArrangedSubview(bottomButtonsStack)
        bottomButtonsStack.orientation = .horizontal
        bottomButtonsStack.alignment = .width
        bottomButtonsStack.distribution = .fillEqually
        bottomButtonsStack.spacing = buttonsStackSpacing
        
        bottomButtonsStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomButtonsStack.leadingAnchor.constraint(equalTo: mainVStack.leadingAnchor),
            bottomButtonsStack.trailingAnchor.constraint(equalTo: mainVStack.trailingAnchor)
        ])
        
        bottomButtonsStack.addArrangedSubview(recordButton)
        recordButton.title = recordButtonStartTitle
        recordButton.bezelStyle = .rounded
        
        bottomButtonsStack.addArrangedSubview(captureButton)
        captureButton.title = captureButtonStartTitle
        captureButton.bezelStyle = .rounded
        
        bottomButtonsStack.addArrangedSubview(broadcastButton)
        broadcastButton.title = broadcastButtonStartTitle
        broadcastButton.bezelStyle = .rounded
        
        bottomButtonsStack.addArrangedSubview(clipButton)
        clipButton.title = clipButtonStartTitle
        clipButton.bezelStyle = .rounded
    }
    
    // MARK: - Actions
    @objc
    private func didTapCameraCheckBoxButton() {
        delegate?.didTapCameraCheckBoxButton()
    }
    
    @objc
    private func didTapMicrophoneCheckBox() {
        delegate?.didTapMicrophoneCheckBox()
    }
    
    @objc
    private func didTapGetClipButton() {
        delegate?.didTapGetClipButton()
    }
    
    @objc
    private func didTapRecordButton() {
        delegate?.didTapRecordButton()
    }
    
    @objc
    private func didTapCaptureButton() {
        delegate?.didTapCaptureButton()
    }
    
    @objc
    private func didTapBroadcastButton() {
        delegate?.didTapBroadcastButton()
    }
    
    @objc
    private func didTapClipButton() {
        delegate?.didTapClipButton()
    }
}

#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct MainViewControllerView_Previews: PreviewProvider {
    
    static var devices = AppConstants.previewDevices
    
    static var platform: PreviewPlatform? {
        return SwiftUI.PreviewPlatform.macOS
    }
    
    static var previews: some SwiftUI.View {
        NSViewPreview {
            return MainViewControllerView(frame: NSRect.zero)
        }
        .frame(minWidth: 480, maxWidth: .infinity, minHeight: 270.0, maxHeight: .infinity, alignment: .center)
    }
}
#endif

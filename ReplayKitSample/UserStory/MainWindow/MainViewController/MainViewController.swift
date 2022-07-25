/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 The app's main view controller object.
 */

import Cocoa
import ReplayKit
import Photos

final class MainViewController: NSViewController {
    
    // Internal state variables.
    private var isActive = false
    private var replayPreviewViewController: NSWindow!
    private var activityController: RPBroadcastActivityController!
    private var broadcastControl: RPBroadcastController!
    private var cameraView: NSView?
    
    private let contentView: MainViewControllerView
    
    // MARK: - Life cycle
    deinit {
        
    }
    
    init(rect: NSRect) {
        contentView = MainViewControllerView(frame: rect)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.delegate = self
        
        // Initialize the recording state.
        isActive = false
        
        // Initialize the screen recorder delegate.
        RPScreenRecorder.shared().delegate = self
        
        let isEnabled = RPScreenRecorder.shared().isAvailable
        contentView.setRecordButtonState(isEnabled: isEnabled)
        contentView.setCaptureButtonState(isEnabled: isEnabled)
        contentView.setBroadcastButtonState(isEnabled: isEnabled)
        contentView.setClipButtonState(isEnabled: isEnabled)
    }
    
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
                cameraView.frame = NSRect(x: 0, y: self.view.frame.size.height - 100, width: 100, height: 100)
                // Ensure that the view is layer-backed.
                cameraView.wantsLayer = true
                // Add the camera view as a subview to the main view.
                self.view.addSubview(cameraView)
                
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
    
    func startRecording() {
        RPScreenRecorder.shared().startRecording { error in
            // If there is an error, print it and set the button title and state.
            if error == nil {
                // There isn't an error and recording starts successfully. Set the recording state.
                self.setRecordingState(active: true)
                
                // Set up the camera view.
                self.setupCameraView()
            } else {
                // Print the error.
                print("Error starting recording")
                
                // Set the recording state.
                self.setRecordingState(active: false)
            }
        }
    }
    
    func stopRecording() {
        RPScreenRecorder.shared().stopRecording { previewViewController, error in
            if error == nil {
                // There isn't an error and recording stops successfully. Present the view controller.
                print("Presenting Preview View Controller")
                if previewViewController != nil {
                    DispatchQueue.main.async {
                        // Set the internal preview view controller window.
                        self.replayPreviewViewController = NSWindow(contentViewController: previewViewController!)
                        
                        // Set the delegate so you know when to dismiss the preview view controller.
                        previewViewController?.previewControllerDelegate = self
                        
                        // Present the preview view controller from the main window as a sheet.
                        NSApplication.shared.mainWindow?.beginSheet(self.replayPreviewViewController, completionHandler: nil)
                    }
                } else {
                    // There isn't a preview view controller, so print an error.
                    print("No preview view controller to present")
                }
            } else {
                // There's an error stopping the recording, so print an error message.
                print("Error starting recording")
            }
            
            // Set the recording state.
            self.setRecordingState(active: false)
            
            // Tear down the camera view.
            self.tearDownCameraView()
            
        }
    }
    
    func setRecordingState(active: Bool) {
        DispatchQueue.main.async {
            print(active ? "started recording" : "stopped recording")
            self.contentView.setRecordButtonTitle(isRecording: active)
            
            // Set the internal recording state.
            self.isActive = active
            
            // Set the other buttons' isEnabled properties.
            self.contentView.setCaptureButtonState(isEnabled: !active)
            self.contentView.setBroadcastButtonState(isEnabled: !active)
            self.contentView.setClipButtonState(isEnabled: !active)
        }
    }
    
    func startCapture() {
        RPScreenRecorder.shared().startCapture { sampleBuffer, sampleBufferType, error in
            // The sample calls this handler every time ReplayKit is ready to give you a video, audio or microphone sample.
            // You need to check several things here so that you can process these sample buffers correctly.
            // Check for an error and, if there is one, print it.
            if error != nil {
                print("Error receiving sample buffer for in app capture")
            } else {
                // There isn't an error. Check the sample buffer for its type.
                switch sampleBufferType {
                case .video:
                    self.processAppVideoSample(sampleBuffer: sampleBuffer)
                case .audioApp:
                    self.processAppAudioSample(sampleBuffer: sampleBuffer)
                case .audioMic:
                    self.processAppMicSample(sampleBuffer: sampleBuffer)
                default:
                    print("Unable to process sample buffer")
                }
            }
        } completionHandler: { error in
            // The sample calls this handler when the capture session starts. It only calls it once.
            // Use this handler to set your started capture state and variables.
            if error == nil {
                // There's no error when attempting to start an in-app capture session. Update the capture state.
                self.setCaptureState(active: true)
                
                // Set up the camera view.
                self.setupCameraView()
            } else {
                // There's an error when attempting to start the in-app capture session. Print an error.
                print("Error starting in app capture session")
                
                // Update the capture state.
                self.setCaptureState(active: false)
            }
        }
    }
    
    func processAppVideoSample(sampleBuffer: CMSampleBuffer) {
        // An app can modify the video sample buffers as necessary.
        // The sample simply prints a message to the console.
        print("Received a video sample.")
    }
    
    func processAppAudioSample(sampleBuffer: CMSampleBuffer) {
        // An app can modify the audio sample buffers as necessary.
        // The sample simply prints a message to the console.
        print("Received an audio sample.")
    }
    
    func processAppMicSample(sampleBuffer: CMSampleBuffer) {
        // An app can modify the microphone audio sample buffers as necessary.
        // The sample simply prints a message to the console.
        print("Received a microphone audio sample.")
    }
    
    func stopCapture() {
        RPScreenRecorder.shared().stopCapture { error in
            // The sample calls the handler when the stop capture finishes. Update the capture state.
            self.setCaptureState(active: false)
            
            // Tear down the camera view.
            self.tearDownCameraView()
            
            // Check and print the error, if necessary.
            if error != nil {
                print("Encountered and error attempting to stop in app capture")
            }
        }
    }
    
    func setCaptureState(active: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.contentView.setCaptureButtonTitle(isCapturing: active)
            
            // Set the internal recording state.
            strongSelf.isActive = active
            
            // Set the other buttons' isEnabled properties.
            strongSelf.contentView.setRecordButtonState(isEnabled: !active)
            strongSelf.contentView.setBroadcastButtonState(isEnabled: !active)
            strongSelf.contentView.setClipButtonState(isEnabled: !active)
        }
    }
    
    func presentBroadcastPicker() {
        // Set the origin point for the broadcast picker.
        let broadcastPickerOriginPoint = CGPoint.zero
        
        // Show the broadcast picker.
        RPBroadcastActivityController.showBroadcastPicker(at: broadcastPickerOriginPoint,
                                                          from: NSApplication.shared.mainWindow,
                                                          preferredExtensionIdentifier: nil) { broadcastActivtyController, error in
            if error == nil {
                // There isn't an error presenting the broadcast picker.
                // Save the broadcast activity controller reference.
                self.activityController = broadcastActivtyController
                
                // Set the broadcast activity controller delegate so that you
                // can get the RPBroadcastController when the user finishes with the picker.
                self.activityController.delegate = self
            } else {
                // There's an error when attempting to present the broadcast picker, so print the error.
                print("Error attempting to present broadcast activity controller")
            }
        }
    }
    
    func stopBroadcast() {
        broadcastControl.finishBroadcast { error in
            // Update the broadcast state.
            self.setBroadcastState(active: false)
            
            // Tear down the camera view.
            self.tearDownCameraView()
            
            // Check and print the error, if necessary.
            if error != nil {
                print("Error attempting to stop in app broadcast")
            }
        }
    }
    
    func setBroadcastState(active: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.contentView.setBroadcastButtonTitle(isBroadcasting: true)
            
            // Set the internal recording state.
            strongSelf.isActive = active
            
            // Set the other buttons' isEnabled properties.
            strongSelf.contentView.setRecordButtonState(isEnabled: !active)
            strongSelf.contentView.setCaptureButtonState(isEnabled: !active)
            strongSelf.contentView.setClipButtonState(isEnabled: !active)
        }
    }
    
    func startClipBuffering() {
        RPScreenRecorder.shared().startClipBuffering { (error) in
            if error != nil {
                print("Error attempting to start Clip Buffering")
                
                self.setClipState(active: false)
                
            } else {
                // There's no error when attempting to start a clip session. Update the clip state.
                self.setClipState(active: true)
                
                // Set up the camera view.
                self.setupCameraView()
            }
        }
    }
    
    func stopClipBuffering() {
        RPScreenRecorder.shared().stopClipBuffering { (error) in
            if error != nil {
                print("Error attempting to stop Clip Buffering")
            }
            // The sample calls this handler when stopClipBuffering finishes. Update the clip state.
            self.setClipState(active: false)
            
            // Tear down the camera view.
            self.tearDownCameraView()
        }
    }
    
    func setClipState(active: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.contentView.setClipButtonTitle(isCliping: active)
            
            // Set the internal recording state.
            strongSelf.isActive = active
            
            // Set the getClip button.
            strongSelf.contentView.setGetClipButtonState(isEnabled: active)
            
            // Set the other buttons' isEnabled properties.
            strongSelf.contentView.setRecordButtonState(isEnabled: !active)
            strongSelf.contentView.setBroadcastButtonState(isEnabled: !active)
            strongSelf.contentView.setCaptureButtonState(isEnabled: !active)
        }
    }
    
    func exportClip() {
        let clipURL = getDirectory()
        let interval = TimeInterval(5)
        
        print("Generating clip at URL: ", clipURL)
        RPScreenRecorder.shared().exportClip(to: clipURL, duration: interval) { error in
            if error != nil {
                print("Error attempting to start Clip Buffering")
            } else {
                // There isn't an error, so save the clip at the URL to Photos.
                self.saveToPhotos(tempURL: clipURL)
            }
        }
    }
    
    func getDirectory() -> URL {
        var tempPath = URL(fileURLWithPath: NSTemporaryDirectory())
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd-hh-mm-ss"
        let stringDate = formatter.string(from: Date())
        print(stringDate)
        tempPath.appendPathComponent(String.localizedStringWithFormat("output-%@.mp4", stringDate))
        return tempPath
    }
    
    func saveToPhotos(tempURL: URL) {
        PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: tempURL)
        } completionHandler: { success, error in
            if success == true {
                print("Saved to photos")
            } else {
                print("Error exporting clip to Photos")
            }
        }
    }
    
}

// MARK: - MainViewControllerViewDelegate
extension MainViewController: MainViewControllerViewDelegate {
    
    func didTapCameraCheckBoxButton() {
        if contentView.getCameraCheckBoxState() == .on {
            RPScreenRecorder.shared().isCameraEnabled = true
        } else {
            RPScreenRecorder.shared().isCameraEnabled = false
        }
    }
    
    func didTapMicrophoneCheckBox() {
        if contentView.getMicrophoneCheckBox() == .on {
            RPScreenRecorder.shared().isMicrophoneEnabled = true
        } else {
            RPScreenRecorder.shared().isMicrophoneEnabled = false
        }
    }
    
    func didTapGetClipButton() {
        if self.isActive == true && self.contentView.getClipButtonState() == true {
            exportClip()
        }
    }
    
    func didTapRecordButton() {
        // Check the internal recording state.
        if isActive == false {
            // If a recording isn't currently underway, start it.
            startRecording()
        } else {
            // If a recording is active, the button stops it.
            stopRecording()
        }
    }
    
    func didTapCaptureButton() {
        // Check the internal recording state.
        if isActive == false {
            // If a recording isn't active, the button starts the capture session.
            startCapture()
        } else {
            // If a recording is active, the button stops the capture session.
            stopCapture()
        }
    }
    
    func didTapBroadcastButton() {
        // Check the internal recording state.
        if isActive == false {
            // If not active, present the broadcast picker.
            presentBroadcastPicker()
        } else {
            // If currently active, the button stops the broadcast session.
            stopBroadcast()
        }
    }
    
    func didTapClipButton() {
        // Check the internal recording state.
        if isActive == false {
            // If the recording isn't active, the button starts the clip buffering session.
            startClipBuffering()
        } else {
            // If a recording is active, the button stops the clip buffering session.
            stopClipBuffering()
        }
    }
}

// MARK: - RPPreviewViewControllerDelegate
extension MainViewController: RPPreviewViewControllerDelegate {
    
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        // This delegate method tells the app when the user finishes with the
        // preview view controller sheet (when the user exits or cancels the sheet).
        // End the presentation of the preview view controller here.
        DispatchQueue.main.async {
            NSApplication.shared.mainWindow?.endSheet(self.replayPreviewViewController)
        }
    }
}

// MARK: - RPBroadcastControllerDelegate
extension MainViewController: RPBroadcastControllerDelegate {
    
}

// MARK: - RPBroadcastActivityControllerDelegate
extension MainViewController: RPBroadcastActivityControllerDelegate {
    
    func broadcastActivityController(_ broadcastActivityController: RPBroadcastActivityController,
                                     didFinishWith broadcastController: RPBroadcastController?,
                                     error: Error?) {
        if error == nil {
            // Assign the private variable to the broadcast controller that you pass so that you
            // can control the broadcast.
            broadcastControl = broadcastController
            
            // Start the broadcast.
            broadcastControl.startBroadcast { error in
                // Update the broadcast state.
                self.setBroadcastState(active: true)
                
                // Set up the camera view.
                self.setupCameraView()
            }
        } else {
            // Print an error.
            print("Error with broadcast activity controller delegate call didFinish")
        }
    }
}

// MARK: - RPScreenRecorderDelegate
extension MainViewController: RPScreenRecorderDelegate {
    
    /// This delegate call lets the developer know when the screen recorder's availability changes.
    func screenRecorderDidChangeAvailability(_ screenRecorder: RPScreenRecorder) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            let isEnabled = screenRecorder.isAvailable
            strongSelf.contentView.setRecordButtonState(isEnabled: isEnabled)
            strongSelf.contentView.setCaptureButtonState(isEnabled: isEnabled)
            strongSelf.contentView.setBroadcastButtonState(isEnabled: isEnabled)
            strongSelf.contentView.setClipButtonState(isEnabled: isEnabled)
        }
    }
    
    func screenRecorder(_ screenRecorder: RPScreenRecorder, didStopRecordingWith previewViewController: RPPreviewViewController?, error: Error?) {
        // This delegate call lets you know if any of the ongoing recording or capture stops.
        // If there's a preview view controller to give back, present it here.
        print("delegate didstoprecording with previewViewController")
        DispatchQueue.main.async {
            // Reset the UI state.
            print("inside delegate call")
            self.isActive = false
            self.contentView.setRecordButtonTitle(isRecording: false)
            self.contentView.setCaptureButtonTitle(isCapturing: false)
            self.contentView.setBroadcastButtonTitle(isBroadcasting: false)
            self.contentView.setClipButtonTitle(isCliping: false)
            self.contentView.setRecordButtonState(isEnabled: true)
            self.contentView.setCaptureButtonState(isEnabled: true)
            self.contentView.setBroadcastButtonState(isEnabled: true)
            self.contentView.setClipButtonState(isEnabled: true)
            self.contentView.setGetClipButtonVisibility(isHidden: true)
            self.contentView.setGetClipButtonState(isEnabled: false)
            
            // Tear down the camera view.
            self.tearDownCameraView()
            
            // There isn't an error and the stop recording is successful. Present the view controller.
            if previewViewController != nil {
                // Set the internal preview view controller window.
                self.replayPreviewViewController = NSWindow(contentViewController: previewViewController!)
                
                // Set the delegate so you know when to dismiss the preview view controller.
                previewViewController?.previewControllerDelegate = self
                
                // Present the preview view controller from the main window as a sheet.
                NSApplication.shared.mainWindow?.beginSheet(self.replayPreviewViewController, completionHandler: nil)
            } else {
                // There isn't a preview view controller, so print an error.
                print("No preview view controller to present")
            }
        }
    }
}

// MARK: - SwiftUI Preview
#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct MainViewController_Previews: PreviewProvider {
    
    static var devices = AppConstants.previewDevices
    
    static var platform: PreviewPlatform? {
        return SwiftUI.PreviewPlatform.macOS
    }
    
    static var previews: some SwiftUI.View {
        
        ForEach(devices, id: \.self) { deviceName in
            Group {
                
                NSViewControllerPreview {
                    let rect = NSRect(x: 0, y: 0, width: 480, height: 270)
                    let vc = MainViewController(rect: rect)
                    return vc
                }
                
            }.previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
        
    }
}
#endif

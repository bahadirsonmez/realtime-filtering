//
//  CameraCapture.swift
//  Realtime Filtering
//
//  Created by Bahadır Sönmez on 17.11.2023.
//

import AVFoundation
import CoreImage

class CameraCapture: NSObject {
    typealias Callback = (CIImage?) -> ()
    
    private let position: AVCaptureDevice.Position
    private let callback: Callback
    private let session = AVCaptureSession()
    private let bufferQueue = DispatchQueue(label: "someLabel", qos: .userInitiated)
    
    init(position: AVCaptureDevice.Position = .front, callback: @escaping Callback) {
        self.position = position
        self.callback = callback
        
        super.init()
        configureSession()
    }
    
    func start() {
        session.startRunning()
    }
    
    func stop() {
        session.stopRunning()
    }
    
    private func configureSession() {
        // 1
        session.sessionPreset = .hd1280x720
        
        // 2
        let discovery = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera, .builtInWideAngleCamera], mediaType: .video, position: position)
        guard let camera = discovery.devices.first, let input = try? AVCaptureDeviceInput(device: camera) else {
            // Error handling
            return
        }
        session.addInput(input)
        
        // 3
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: bufferQueue)
        session.addOutput(output)
    }
}

extension CameraCapture: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        DispatchQueue.main.async {
            let image = CIImage(cvImageBuffer: imageBuffer)
            self.callback(image.transformed(by: CGAffineTransform(rotationAngle: 3 * .pi / 2)))
        }
    }
}

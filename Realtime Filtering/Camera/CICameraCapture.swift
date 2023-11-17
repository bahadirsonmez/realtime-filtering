//
//  CICameraCapture.swift
//  Realtime Filtering
//
//  Created by Bahadır Sönmez on 17.11.2023.
//

import AVFoundation
import CoreImage

class CICameraCapture: NSObject {
    typealias Callback = (CIImage?) -> ()
    
    let cameraPosition: AVCaptureDevice.Position
    let callback: Callback
    private let session = AVCaptureSession()
    private let sampleBufferQueue = DispatchQueue(label: "com.bahadirovski-example.SampleBufferQueue", qos: .userInitiated)
    
    init(cameraPosition: AVCaptureDevice.Position, callback: @escaping Callback) {
        self.cameraPosition = cameraPosition
        self.callback = callback
        
        super.init()
        
        prepareSession()
    }
    
    func start() {
        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()
        }
    }
    
    func stop() {
        session.stopRunning()
    }
    
    private func prepareSession() {
        session.sessionPreset = .hd1920x1080
        
        let cameraDiscovery = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera, .builtInWideAngleCamera], mediaType: .video, position: cameraPosition)
        guard let camera = cameraDiscovery.devices.first, let input = try? AVCaptureDeviceInput(device: camera) else {
            fatalError("Can't get hold of the camera")
        }
        session.addInput(input)
        
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: sampleBufferQueue)
        session.addOutput(output)
    }
}

extension CICameraCapture: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        DispatchQueue.main.async {
            let image = CIImage(cvImageBuffer: imageBuffer)
            self.callback(image.transformed(by: CGAffineTransform(rotationAngle: 3 * .pi / 2)))
        }
    }
}

//
//  ViewController.swift
//  Realtime Filtering
//
//  Created by Bahadır Sönmez on 17.11.2023.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

class ViewController: UIViewController {
    var metalView: MetalRenderView!
    var imageView: UIImageView!
    var cameraCapture: CICameraCapture?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        metalView = MetalRenderView(frame: view.bounds, device: MTLCreateSystemDefaultDevice())
        view.addSubview(metalView)
        //        imageView = UIImageView(frame: view.bounds)
        //        view.addSubview(imageView)
        
        cameraCapture = CICameraCapture(cameraPosition: .back, callback: { image in
            guard let image = image else { return }
            //            let filter = CIFilter.thermal()
            let filter2 = CIFilter.xRay()
            //            let filter3 = CIFilter.motionBlur()
            //            filter.setDefaults()
            filter2.setDefaults()
            //            filter3.setDefaults()
            //            filter.inputImage = image
            filter2.inputImage = image
            //            filter3.inputImage = filter2.outputImage!
            
            //            let uiImage = UIImage(ciImage: (filter2.outputImage?.cropped(to: image.extent).transformToOrigin(withSize: self.view.bounds.size))!)
            //            self.imageView.image = uiImage
            self.metalView.setImage(filter2.outputImage?.cropped(to: image.extent))
        })
        
        cameraCapture?.start()
    }
}


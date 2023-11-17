//
//  CIImage+TransformExtent.swift
//  Realtime Filtering
//
//  Created by Bahadır Sönmez on 17.11.2023.
//

import CoreImage

extension CIImage {
    func transformToOrigin(withSize size: CGSize) -> CIImage {
        let originX = extent.origin.x
        let originY = extent.origin.y
        
        let scaleX = size.width / extent.width
        let scaleY = size.height / extent.height
        let scale = max(scaleX, scaleY)
        
        return transformed(by: CGAffineTransform(translationX: -originX, y: -originY))
            .transformed(by: CGAffineTransform(scaleX: scale, y: scale))
    }
}

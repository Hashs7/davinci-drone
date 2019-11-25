//
//  VisionHelpers.swift
//  davinci-drone
//
//  Created by Sébastien Hernoux on 22/11/2019.
//  Copyright © 2019 Sébastien Hernoux. All rights reserved.
//

import Foundation
import Vision
import UIKit

func boundingBox(forRegionOfInterest: CGRect, withinImageBounds bounds: CGRect) -> CGRect {
    let imageWidth = bounds.width
    let imageHeight = bounds.height
    
    // Begin with input rect.
    var rect = forRegionOfInterest
    // Reposition origin.
    rect.origin.x *= imageWidth
    rect.origin.x += bounds.origin.x
    rect.origin.y = (1 - rect.origin.y) * imageHeight + bounds.origin.y
    print("imageHeight \(imageHeight)")
    
    // Rescale normalized coordinates.
    rect.size.width *= imageWidth
    rect.size.height *= imageHeight
    
    return rect
}

func shapeLayer(color: UIColor, frame: CGRect) -> CAShapeLayer {
    // Create a new layer.
    let layer = CAShapeLayer()
    
    // Configure layer's appearance.
    layer.fillColor = nil // No fill to show boxed object
    layer.shadowOpacity = 0
    layer.shadowRadius = 0
    layer.borderWidth = 2
    
    // Vary the line color according to input.
    layer.borderColor = color.cgColor
    
    // Locate the layer.
    layer.anchorPoint = .zero
    layer.frame = frame
    layer.masksToBounds = true
    
    // Transform the layer to have same coordinate system as the imageView underneath it.
    layer.transform = CATransform3DMakeScale(1, -1, 1)
    
    return layer
}

func draw(rectangles: [VNRectangleObservation], onImageWithBounds bounds: CGRect) {
    CATransaction.begin()
    for observation in rectangles {
        let rectBox = boundingBox(forRegionOfInterest: observation.boundingBox, withinImageBounds: bounds)
        let rectLayer = shapeLayer(color: .blue, frame: rectBox)
        
        // Add to pathLayer on top of image.
        //pathLayer?.addSublayer(rectLayer)
    }
    CATransaction.commit()
}

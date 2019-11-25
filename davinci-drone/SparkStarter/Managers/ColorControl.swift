//
//  ColorControl.swift
//  davinci-drone
//
//  Created by Digital on 24/11/2019.
//  Copyright © 2019 Sébastien Hernoux. All rights reserved.
//


import CoreImage

class ColorControl: Saturationable {
    
    // MARK: - Properties
    
    let filter = CIFilter(name: "CIColorControls")!
}

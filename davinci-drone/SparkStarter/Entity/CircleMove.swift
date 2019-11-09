//
//  CircleMove.swift
//  davinci-drone
//
//  Created by Sébastien Hernoux on 09/11/2019.
//  Copyright © 2019 Sébastien Hernoux. All rights reserved.
//

import Foundation
import DJISDK

class CircleMove: BasicAction {
    var stickPos: CGPoint
    
    
    override var description: String {
        get {
            return "Move stick to \(stickPos) during \(duration)s "
        }
    }
    
    init(durationInSec: Float, stickPos: CGPoint) {
        self.stickPos = stickPos
        super.init(duration: durationInSec)
    }
    
    override func talkWithSDK(resetStick: Bool = false) {
        print(self.description)
        
        if let mySpark = DJISDKManager.product() as? DJIAircraft {
            mySpark.mobileRemoteController?.rightStickHorizontal = Float(stickPos.x)
            mySpark.mobileRemoteController?.rightStickVertical = Float(stickPos.y)
        }
    }
}

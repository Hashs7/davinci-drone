//
//  BasicMove.swift
//  SparkPerso
//
//  Created by Sébastien Hernoux on 18/10/2019.
//  Copyright © 2019 AlbanPerli. All rights reserved.
//

import Foundation
import DJISDK

class BasicMove: BasicAction {
    var speed: Float
    var dir: Direction
    enum Direction {
        case front, back, up, down, translateLeft, translateRight, rotateLeft, rotateRight, rotate180, rotate90Right, rotate90Left, rotate180AndUp, stop
    }
    
    override var description: String {
        get {
            return "Move \(dir) during \(duration)s at speed \(speed)"
        }
    }
    
    init(direction: Direction, durationInSec: Float, speed: Float) {
        self.dir = direction
        self.speed = speed
        super.init(duration: durationInSec)
    }
    
    override func talkWithSDK(resetStick: Bool = true) {
        let speed = Float(self.speed)
        print(self.description)
        print("reset sticks = \(resetStick)")
        if(resetStick) {
            self.resetSticks()
        }
        
        if let mySpark = DJISDKManager.product() as? DJIAircraft {
            switch dir {
            case .front:
                mySpark.mobileRemoteController?.rightStickVertical = speed
                break
            case .back:
                mySpark.mobileRemoteController?.rightStickVertical = -speed
                break
            case .up:
                mySpark.mobileRemoteController?.leftStickVertical = speed
                break
            case .down:
                mySpark.mobileRemoteController?.leftStickVertical = -speed
                break
            case .rotateRight, .rotate90Right, .rotate180:
                mySpark.mobileRemoteController?.leftStickHorizontal = speed
                break
            case .rotateLeft, .rotate90Left:
                mySpark.mobileRemoteController?.leftStickHorizontal = -speed
                break
            case .rotate180AndUp:
                mySpark.mobileRemoteController?.leftStickHorizontal = 1
                mySpark.mobileRemoteController?.leftStickVertical = speed
                break
            default:
                break
            }
        }
    }
    
    func resetSticks() {
       if let mySpark = DJISDKManager.product() as? DJIAircraft {
           mySpark.mobileRemoteController?.leftStickVertical = 0.0
           mySpark.mobileRemoteController?.leftStickHorizontal = 0.0
           mySpark.mobileRemoteController?.rightStickHorizontal = 0.0
           mySpark.mobileRemoteController?.rightStickVertical = 0.0
       }
    }
}

class Stop: BasicMove {
    init() {
        super.init(direction: .stop, durationInSec: 0.0, speed: 0)
    }
}

class Front: BasicMove {
    init(duration: Float, speed: Float) {
        super.init(direction: .front, durationInSec: duration, speed: speed)
    }
}

class Back: BasicMove {
    init(duration: Float, speed: Float) {
        super.init(direction: .back, durationInSec: duration, speed: speed)
    }
}

class Up: BasicMove {
    init(duration: Float, speed: Float) {
        super.init(direction: .up, durationInSec: duration, speed: speed)
    }
}

class Down: BasicMove {
    init(duration: Float, speed: Float) {
        super.init(direction: .down, durationInSec: duration, speed: speed)
    }
}


class RotateRight: BasicMove {
    init(duration: Float, speed: Float) {
        super.init(direction: .rotateRight, durationInSec: duration, speed: speed)
    }
}

class RotateLeft: BasicMove {
    init(duration: Float, speed: Float) {
        super.init(direction: .rotateLeft, durationInSec: duration, speed: speed)
    }
}

class Rotate180: BasicMove {
    let rotateDuration: Float = 3
    init() {
        super.init(direction: .rotate180, durationInSec: rotateDuration, speed: 1)
    }
}

class RotateRight90: BasicMove {
    let rotateDuration: Float = 1.5
    init() {
        super.init(direction: .rotateRight, durationInSec: rotateDuration, speed: 1)
    }
}

class RotateLeft90: BasicMove {
    let rotateDuration: Float = 1.5
    init() {
        super.init(direction: .rotateLeft, durationInSec: rotateDuration, speed: 1)
    }
}

class Rotate180AndUp: BasicMove {
    let rotateDuration: Float = 1.4
    init(speed: Float) {
        super.init(direction: .rotate180AndUp, durationInSec: rotateDuration, speed: speed)
    }
}

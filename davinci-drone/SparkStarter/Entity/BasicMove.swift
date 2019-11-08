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
    var heading: Double = 180
    var dir: Direction
    enum Direction {
        case front, back, up, down, translateLeft, translateRight, rotateLeft, rotateRight, rotate180, rotate90Right, rotate90Left, stop
    }
    
    override var description: String {
        get {
            return "Move \(dir) during \(duration)s at speed \(speed)"
        }
    }
    
    override func talkWithSDK() {
        let speed = Float(self.speed)
        print(self.description)
        self.resetSticks()
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
            default:
                break
            }
        }
    }
    
    func drawCircle() {
        var stickPositions: [CGPoint] = []

        let radius = Double(0.4)
        let center = CGPoint(x: 0, y: 0)

        for i in stride(from: 0, to: 360.0, by: 20) {
            let radian = i * Double.pi / 180
            let x = Double(center.x) + radius * cos(radian)
            let y = Double(center.y) + radius * sin(radian)
            stickPositions.append(CGPoint(x: x, y: y))
        }

        stickPositions.append(CGPoint(x: radius, y: 0.0))
        stickPositions.append(CGPoint(x: 0.0, y: 0.0))

        stickPositions.forEach { position in
            // Create sequence with moves
            // add delay between each position
            print(position.x, position.y)
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
    
    init(direction: Direction, durationInSec: Float, speed: Float) {
       
        self.dir = direction
        self.speed = speed
         super.init(duration: durationInSec)
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


class SpheroMove: BasicMove {
    init(heading: Double, duration: Float, speed: Float) {
        super.init(direction: .front, durationInSec: duration, speed: speed)
        self.heading = heading
    }
}

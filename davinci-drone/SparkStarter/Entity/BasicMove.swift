//
//  BasicMove.swift
//  SparkPerso
//
//  Created by Sébastien Hernoux on 18/10/2019.
//  Copyright © 2019 AlbanPerli. All rights reserved.
//

import Foundation


class BasicMove:BasicAction {
    var speed: Float
    var heading: Double = 180
    var dir: Direction
    override var description: String {
        get {
            return "Move \(dir) during \(duration)s at speed \(speed)"
        }
    }
    
    enum Direction {
        case front, back, up, down, translateLeft, translateRight, rotateLeft, rotateRight, stop
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
        super.init(direction: .rotateRight, durationInSec: rotateDuration, speed: 1)
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

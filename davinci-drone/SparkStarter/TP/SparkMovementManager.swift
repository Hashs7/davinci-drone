//
//  SparkMovementManager.swift
//  SparkPerso
//
//  Created by Sébastien Hernoux on 18/10/2019.
//  Copyright © 2019 AlbanPerli. All rights reserved.
//

import Foundation
import DJISDK

class SparkMovementManager: GenericMovementManager {
    override init(sequence: [BasicMove]) {
        super.init(sequence: sequence)
        self.sequence.append(Stop())
    }
    
    override func playMove(move: BasicMove, moveDidFinish: @escaping (() -> ())) {
       talkWithSDK(move: move)
        delay(move.duration) {
            moveDidFinish()
        }
    }
    
    func talkWithSDK(move: BasicMove) {
        print(move.description)
        let speed = Float(move.speed)
        
        resetSticks()
        if let mySpark = DJISDKManager.product() as? DJIAircraft {
            switch move {
            case is Front:
                mySpark.mobileRemoteController?.rightStickVertical = speed
                break
            case is RotateRight:
                mySpark.mobileRemoteController?.leftStickHorizontal = speed
                break
            case is RotateLeft:
                mySpark.mobileRemoteController?.leftStickHorizontal = -speed
                break
            case is RotateRight90:
                mySpark.mobileRemoteController?.leftStickHorizontal = speed
                break
            case is RotateLeft90:
                mySpark.mobileRemoteController?.leftStickHorizontal = -speed
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

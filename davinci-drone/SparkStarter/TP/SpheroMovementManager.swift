//
//  SpheroMovementManager.swift
//  SparkPerso
//
//  Created by Sébastien Hernoux on 18/10/2019.
//  Copyright © 2019 AlbanPerli. All rights reserved.
//

import Foundation

class SpheroMovementManager: GenericMovementManager {
    override func playMove(move: BasicMove, moveDidFinish: @escaping (() -> ())) {
       talkWithSDK(move: move)
        delay(move.duration) {
            moveDidFinish()
        }
    }
    
    func talkWithSDK(move: BasicMove) {
        print("Move from sphero")
        SharedToyBox.instance.bolts.map{ $0.roll(heading: move.heading, speed: Double(move.speed)) }
    }
}

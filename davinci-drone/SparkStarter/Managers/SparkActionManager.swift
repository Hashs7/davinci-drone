//
//  SparkActionManager.swift
//  davinci-drone
//
//  Created by Digital on 06/11/2019.
//  Copyright © 2019 Sébastien Hernoux. All rights reserved.
//

import Foundation


class SparkActionManager: GenericActionManager {
    override init(sequence: [BasicAction]) {
        super.init(sequence: sequence)
        self.sequence.append(Stop())
    }
    
    override func doAction(action: BasicAction, moveDidFinish: @escaping (() -> ())) {
        action.talkWithSDK()
        print("action.duration \(action.duration)")
        delay(action.duration) {
            print("action Finished")
            moveDidFinish()
        }
    }
    
    static func createSymbolSequence(sequence: Array<String>) -> Array<BasicAction> {
        var symbolSequence: [BasicAction] = []
        for move in sequence {
            switch move {
            case "front":
                symbolSequence.append(Front(duration: 0.5, speed: 0.3))
                break
            case "back":
                symbolSequence.append(Back(duration: 0.5, speed: 0.3))
                break
            case "left":
                symbolSequence.append(Left(duration: 0.5, speed: 0.3))
                break
            case "right":
                symbolSequence.append(Right(duration: 0.5, speed: 0.3))
                break
            case "blocked":
                print("Blocked move")
                break
            default:
                print("default move")
                break
            }
        }
        return symbolSequence
    }
}

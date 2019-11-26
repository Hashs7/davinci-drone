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
                symbolSequence.append(Front(duration: 1.3, speed: 0.2))
                break
            case "back":
                symbolSequence.append(Back(duration: 1.3, speed: 0.2))
                break
            case "left":
                symbolSequence.append(Left(duration: 1.4, speed: 0.2))
                break
            case "right":
                symbolSequence.append(Right(duration: 1.4, speed: 0.2))
                break
            case "blocked":
                print("Blocked move")
                break
            default:
                print("default move")
                break
            }
            symbolSequence.append(Stop())
            symbolSequence.append(BasicAction(duration: 1.0))
        }
        return symbolSequence
    }
    
    static func createSymbolSequenceColor(color: String) -> Array<BasicAction> {
        var sequence: [BasicAction] = []
        for move in sequence {
            switch color {
            case "White":
                sequence.append(Right(duration: 1.3, speed: 0.2))
                sequence.append(Stop())
                sequence.append(BasicAction(duration: 1.0))
                sequence.append(Right(duration: 1.3, speed: 0.2))
                sequence.append(Stop())
                sequence.append(BasicAction(duration: 1.0))
                sequence.append(Back(duration: 1.3, speed: 0.2))
                sequence.append(Stop())
                sequence.append(BasicAction(duration: 1.0))
                break
                
            case "Blue":
                sequence.append(Right(duration: 1.3, speed: 0.2))
                sequence.append(Stop())
                sequence.append(BasicAction(duration: 1.0))
                sequence.append(Front(duration: 1.3, speed: 0.2))
                sequence.append(Stop())
                sequence.append(BasicAction(duration: 1.0))
                sequence.append(Front(duration: 1.3, speed: 0.2))
                sequence.append(Stop())
                sequence.append(BasicAction(duration: 1.0))
                break
                
            case "Yellow":
                sequence.append(Left(duration: 1.3, speed: 0.2))
                sequence.append(Stop())
                sequence.append(BasicAction(duration: 1.0))
                sequence.append(Left(duration: 1.3, speed: 0.2))
                sequence.append(Stop())
                sequence.append(BasicAction(duration: 1.0))
                sequence.append(Left(duration: 1.3, speed: 0.2))
                sequence.append(Stop())
                sequence.append(BasicAction(duration: 1.0))
                sequence.append(Front(duration: 1.3, speed: 0.2))
                sequence.append(Stop())
                sequence.append(BasicAction(duration: 1.0))
                break

            case "Red":
                sequence.append(Front(duration: 1.3, speed: 0.2))
                sequence.append(Stop())
                sequence.append(BasicAction(duration: 1.0))
                sequence.append(Right(duration: 1.3, speed: 0.2))
                sequence.append(Stop())
                sequence.append(BasicAction(duration: 1.0))
                sequence.append(Right(duration: 1.3, speed: 0.2))
                sequence.append(Stop())
                sequence.append(BasicAction(duration: 1.0))
                sequence.append(Right(duration: 1.3, speed: 0.2))
                sequence.append(Stop())
                sequence.append(BasicAction(duration: 1.0))
                sequence.append(Back(duration: 1.3, speed: 0.2))
                sequence.append(Stop())
                sequence.append(BasicAction(duration: 1.0))
                break
                
            case "Green":
                sequence.append(Left(duration: 1.3, speed: 0.2))
                sequence.append(Stop())
                sequence.append(BasicAction(duration: 1.0))
                sequence.append(Back(duration: 1.3, speed: 0.2))
                sequence.append(Stop())
                sequence.append(BasicAction(duration: 1.0))
                sequence.append(Back(duration: 1.3, speed: 0.2))
                break
                
            case "Blocked":
                print("Blocked move")
                // TODO Execute sequence received
                break
            default:
                print("default move")
                break
            }

        }
        return sequence
    }
}

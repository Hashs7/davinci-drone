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
        delay(action.duration) {
            moveDidFinish()
        }
    }
    
    static func createSymbolSequence(sequence: Array<String>, duration: Float = 1.3) -> Array<BasicAction> {
        var symbolSequence: [BasicAction] = []
        for move in sequence {
            switch move {
            case "front":
                symbolSequence.append(Front(duration: duration+0.1, speed: 0.2))
                break
            case "back":
                symbolSequence.append(Back(duration: duration+0.1, speed: 0.2))
                break
            case "left":
                symbolSequence.append(Left(duration: duration, speed: 0.2))
                break
            case "right":
                symbolSequence.append(Right(duration: duration, speed: 0.2))
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
        print("symbol color \(color)")
        switch color {
        case "White":
            sequence.append(Right(duration: 1.4, speed: 0.2))
            sequence.append(Stop())
            sequence.append(BasicAction(duration: 2.0))
            sequence.append(Right(duration: 2, speed: 0.2))
            sequence.append(Stop())
            sequence.append(BasicAction(duration: 2.0))
            sequence.append(Back(duration: 1, speed: 0.2))
            sequence.append(Stop())
            sequence.append(BasicAction(duration: 2.0))
            break
            
        case "Blue":
            sequence.append(Right(duration: 2.3, speed: 0.2))
            sequence.append(Stop())
            sequence.append(BasicAction(duration: 2.0))
            sequence.append(Front(duration: 1.5, speed: 0.2))
            sequence.append(Stop())
            sequence.append(BasicAction(duration: 2.0))
            sequence.append(Front(duration: 1.8, speed: 0.2))
            sequence.append(Stop())
            sequence.append(BasicAction(duration: 2.0))
            break
            
        case "Yellow":
            sequence.append(Left(duration: 1.5, speed: 0.2))
            sequence.append(Stop())
            sequence.append(BasicAction(duration: 2.0))
            sequence.append(Left(duration: 1.6, speed: 0.2))
            sequence.append(Stop())
            sequence.append(BasicAction(duration: 2.0))
            sequence.append(Left(duration: 1.75, speed: 0.2))
            sequence.append(Stop())
            sequence.append(BasicAction(duration: 2.0))
            sequence.append(Front(duration: 2.0, speed: 0.2))
            break

        case "Red":
            print("Red")
            sequence.append(Front(duration: 1.7, speed: 0.2))
            sequence.append(Stop())
            sequence.append(BasicAction(duration: 2.0))
            sequence.append(Right(duration: 1.6, speed: 0.2))
            sequence.append(Stop())
            sequence.append(BasicAction(duration: 2.0))
            sequence.append(Right(duration: 1.7, speed: 0.2))
            sequence.append(Stop())
            sequence.append(BasicAction(duration: 2.0))
            sequence.append(Right(duration: 1.9, speed: 0.2))
            sequence.append(Stop())
            sequence.append(BasicAction(duration: 2.0))
            sequence.append(Back(duration: 1.4, speed: 0.2))
            break
            
        case "Green":
            sequence.append(Left(duration: 1.6, speed: 0.2))
            sequence.append(Stop())
            sequence.append(BasicAction(duration: 2.0))
            sequence.append(Back(duration: 1.5, speed: 0.2))
            sequence.append(Stop())
            sequence.append(BasicAction(duration: 2.0))
            sequence.append(Back(duration: 1.6, speed: 0.2))
            break
            
        case "Blocked":
            print("Blocked move")
            // TODO Execute sequence received
            break
        default:
            print("default move")
            break
        }

        return sequence
    }
}

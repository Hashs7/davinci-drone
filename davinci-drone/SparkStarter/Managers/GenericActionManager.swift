//
//  GenericActionManager.swift
//  davinci-drone
//
//  Created by Digital on 06/11/2019.
//  Copyright © 2019 Sébastien Hernoux. All rights reserved.
//

import Foundation

class GenericActionManager {
    var sequence: [BasicAction]
    var stopAll: Bool = false
    
    init(sequence: [BasicAction]) {
        self.sequence = sequence
    }
    
    func sequenceDescription() -> String {
        var fullDescription = ""
        for move in sequence {
            fullDescription += "\(move.description)\n"
        }
        return fullDescription
    }
    
  
    func playSequence() {
        stopAll = false
        startSequence(sequence: self.sequence)
    }
    
    func startSequence(sequence: [BasicAction]) {
        if(sequence.count == 0 || stopAll) {
            print("Finish sequence")
        } else {
            if let first = sequence.first {
                doAction(action: first) {
                    let seqMinusFirst = Array(sequence.dropFirst())
                    self.startSequence(sequence: seqMinusFirst)
                }
            }
        }
    }

    func doAction(action: BasicAction, moveDidFinish: @escaping (()->())) {
        print(action.description)
        delay(action.duration) {
            moveDidFinish()
        }
    }
    
    func stopSequence() {
        print("STOP SEQUENCE")
        self.stopAll = true
        self.sequence = []
        doAction(action: Stop()) {
            print("Secure Stop")
        }
    }
    
    func clearSequence() {
        self.sequence = []
    }
}

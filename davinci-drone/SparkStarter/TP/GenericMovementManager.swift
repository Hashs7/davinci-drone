//
//  GenericMovementManager.swift
//  SparkPerso
//
//  Created by Sébastien Hernoux on 18/10/2019.
//  Copyright © 2019 AlbanPerli. All rights reserved.
//

import Foundation

class GenericMovementManager {
    var sequence: [BasicMove]
    var stopAll: Bool = false
    
    init(sequence: [BasicMove]) {
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
    
    func startSequence(sequence: [BasicMove]) {
        if(sequence.count == 0 || stopAll) {
            print("Finish sequence")
        } else {
            if let move = sequence.first {
                playMove(move: move) {
                    print("finish move")
                    let seqMinusFirst = Array(sequence.dropFirst())
                    self.startSequence(sequence: seqMinusFirst)
                }
            }
        }
    }

    func playMove(move: BasicMove, moveDidFinish: @escaping (()->())) {
        print(move.description)
        delay(move.duration) {
            moveDidFinish()
        }
    }
    
    func stopSequence() {
        print("STOP SEQUENCE")
        self.stopAll = true
        self.sequence = []
        playMove(move: Stop()) {
            print("Secure Stop")
        }
    }
    
    func clearSequence() {
        self.sequence = []
    }
}

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
    
}

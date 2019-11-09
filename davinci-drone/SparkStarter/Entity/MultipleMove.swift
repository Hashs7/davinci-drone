//
//  ComplexMove.swift
//  davinci-drone
//
//  Created by Sébastien Hernoux on 09/11/2019.
//  Copyright © 2019 Sébastien Hernoux. All rights reserved.
//

import Foundation
import DJISDK

class MultipleMove: BasicAction {
    var actions: [BasicMove]
    var totalDuration: Float = 0
    
    override var description: String {
        get {
            var desc: String = ""
            for action in actions {
                desc += action.description + "\n";
            }
            return desc
        }
    }
    
    init(actions: [BasicMove]) {
        self.actions = actions
        for action in actions {
            if(self.totalDuration < action.duration) {
                self.totalDuration = action.duration
            }
        }
        print("totalDuration \(totalDuration)")
        super.init(duration: totalDuration)
    }
    
    override func talkWithSDK(resetStick: Bool) {
        for (index, action) in actions.enumerated() {
            var reset = false
            if index == 0 {
                reset = true
            }
            action.talkWithSDK(resetStick: reset)
        }
    }
}

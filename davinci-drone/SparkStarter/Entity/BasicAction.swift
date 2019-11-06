//
//  BasicAction.swift
//  davinci-drone
//
//  Created by Digital on 06/11/2019.
//  Copyright © 2019 Sébastien Hernoux. All rights reserved.
//

import Foundation

class BasicAction{
    var duration:Float
    
    init(duration:Float){
        self.duration = duration
    }
    
    var description: String{
        get {
            return "Move  during \(duration)"
        }
    }
    
    func talkWithSDK(){
        print("BasicAction")
    }
}

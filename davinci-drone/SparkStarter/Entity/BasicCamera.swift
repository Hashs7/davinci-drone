//
//  BasicCamera.swift
//  davinci-drone
//
//  Created by Digital on 06/11/2019.
//  Copyright © 2019 Sébastien Hernoux. All rights reserved.
//

import Foundation
import VideoPreviewer

class BasicCamera:BasicAction{
    var action:Action
    override var description: String{
        get {
            return "Move \(action) during \(duration)"
        }
    }
    enum Action {
           case takePic, front, under
       }
    
    init(duration:Float, action:Action) {
        self.action = action
        super.init(duration:duration)
    }

}


class PictureAction:BasicCamera{
    var imageView:UIImageView
    var previewer:VideoPreviewer
    init(imageView:UIImageView, previewer:VideoPreviewer) {
    self.imageView = imageView
    self.previewer = previewer
    super.init(duration: 0,action: .takePic)
   }
}

class LookUnder:BasicCamera{

    init(duration:Float) {
    super.init(duration: duration,action: .under)
   }
}

class LookFront:BasicCamera{
    
    init(duration:Float) {
    super.init(duration: duration,action: .front)
   }
}

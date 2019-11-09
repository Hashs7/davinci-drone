//
//  BasicCamera.swift
//  davinci-drone
//
//  Created by Digital on 06/11/2019.
//  Copyright © 2019 Sébastien Hernoux. All rights reserved.
//

import Foundation
import VideoPreviewer

class BasicCamera: BasicAction {
    var action: Action
    override var description: String {
        get {
            return "Move \(action) during \(duration)"
        }
    }
    enum Action {
           case takePic, front, under
       }
    
    override func talkWithSDK(resetStick: Bool = false) {
        print("Camera Action")
    }
    
    init(duration:Float, action:Action) {
        self.action = action
        super.init(duration:duration)
    }
}

class PictureAction: BasicCamera{
    var imageView: UIImageView
    var previewer: VideoPreviewer
    init(imageView: UIImageView, previewer: VideoPreviewer) {
        self.imageView = imageView
        self.previewer = previewer
        super.init(duration: 0,action: .takePic)
    }
    
    override func talkWithSDK(resetStick: Bool = false) {
        takePicture(imageView: self.imageView, previewer: self.previewer)
    }
    
    func takePicture(imageView:UIImageView, previewer:VideoPreviewer) {
        print("take picture")
        previewer.snapshotThumnnail { (image) in
           if let img = image {
            imageView.image = img
           }
        }
    }
}

class LookUnder: BasicCamera{
    func lookUnder() {
        print("look under")
        GimbalManager.shared.lookUnder()
    }
    
    override func talkWithSDK(resetStick: Bool = false) {
        lookUnder()
    }
    
    init(duration:Float) {
    super.init(duration: duration,action: .under)
   }
}

class LookFront: BasicCamera{
    func lookFront() {
        print("look front")
        GimbalManager.shared.lookFront()
    }
    
    override func talkWithSDK(resetStick: Bool = false) {
        lookFront()
    }
    
    init(duration:Float) {
    super.init(duration: duration,action: .front)
   }
}

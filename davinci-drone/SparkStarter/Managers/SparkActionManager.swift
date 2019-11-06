//
//  SparkActionManager.swift
//  davinci-drone
//
//  Created by Digital on 06/11/2019.
//  Copyright © 2019 Sébastien Hernoux. All rights reserved.
//

import Foundation
import DJISDK
import VideoPreviewer

class SparkActionManager: GenericActionManager {
    override init(sequence: [BasicAction]) {
        super.init(sequence: sequence)
        self.sequence.append(Stop())
    }
    
    override func doAction(action: BasicAction, moveDidFinish: @escaping (() -> ())) {
       //cameraSdk(action: action)
        print(action.duration)
        delay(action.duration) {
            moveDidFinish()
        }
    }
    

    /**Moves**/
    func moveAction(action:BasicMove){
        talkWithSDK(move: action)
        switch action {
        case is Rotate180:
            print("Rotate180")
        case is Up:
            print("Up now")
        default:
            break
        }
    }
    func pictureAction(action:PictureAction){
        takePicture(imageView: action.imageView, previewer: action.previewer)
    }
    
    /**Camera**/
    func cameraAction(action:BasicCamera){
         switch action {
         case is LookUnder:
             lookUnder()
         default:
             break
         }
     }
    
    
    func takePicture(imageView:UIImageView, previewer:VideoPreviewer) {
        previewer.snapshotThumnnail { (image) in
                   if let img = image {
                    imageView.image = img
                   }
               }
       }
    
    func lookUnder() {
           GimbalManager.shared.lookUnder()
       }
    
    
    
    func talkWithSDK(move: BasicMove) {
        print(move.description)
        let speed = Float(move.speed)
        
        resetSticks()
        if let mySpark = DJISDKManager.product() as? DJIAircraft {
            switch move {
            case is Front:
                mySpark.mobileRemoteController?.rightStickVertical = speed
                break
            case is Up:
                mySpark.mobileRemoteController?.leftStickVertical = speed
            break
            case is Down:
                    mySpark.mobileRemoteController?.leftStickVertical = -speed
            break
            case is RotateRight,is RotateRight90, is Rotate180:
                mySpark.mobileRemoteController?.leftStickHorizontal = speed
                break
            case is RotateLeft, is RotateLeft90:
                mySpark.mobileRemoteController?.leftStickHorizontal = -speed
                break
            default:
                break
            }
        }
    }
    
    func resetSticks() {
        if let mySpark = DJISDKManager.product() as? DJIAircraft {
            mySpark.mobileRemoteController?.leftStickVertical = 0.0
            mySpark.mobileRemoteController?.leftStickHorizontal = 0.0
            mySpark.mobileRemoteController?.rightStickHorizontal = 0.0
            mySpark.mobileRemoteController?.rightStickVertical = 0.0
        }
    }
}

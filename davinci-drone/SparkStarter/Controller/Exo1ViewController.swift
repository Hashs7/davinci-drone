//
//  Exo1ViewController.swift
//  davinci-drone
//
//  Created by Digital on 06/11/2019.
//  Copyright © 2019 Sébastien Hernoux. All rights reserved.
//

import Foundation
import UIKit
import DJISDK
import VideoPreviewer
//import ImageDetect

class Exo1ViewController: UIViewController {

    var sequence = [BasicAction]()
    @IBOutlet weak var extractedFrameImageView1: UIImageView!
    
    @IBOutlet weak var extractedFrameImageView2: UIImageView!
    var sparkMovementManager: SparkActionManager? = nil

    let prev1 = VideoPreviewer()
    @IBOutlet weak var cameraView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
 
    @IBAction func stopBtnHandler(_ sender: Any) {
       stop()
    }

    @IBAction func startBtnHandler(_ sender: Any) {
       print("Start")
    }

    //EXERCICE 1
    @IBAction func exo1Handler(_ sender: Any) {
        sequence = []

        sequence.append(MultipleMove(actions: [ Up(duration: 3, speed: 0.2), RotateRight(duration: 3, speed: 1.0)] ))
        //sequence.append(Rotate180AndUp(speed: 0.2))
        sequence.append(Stop())
        sequence.append(LookUnder(duration: 0.5))
        sequence.append(BasicAction(duration: 1.0))
        if let previewer1 = prev1 {
             sequence.append(PictureAction(imageView: extractedFrameImageView1, previewer: previewer1))
        }
        sequence.append(BasicAction(duration: 0.5))
        sequence.append(LookFront(duration: 0.5))
        sequence.append(Back(duration: 2.5, speed: 0.3))
        sequence.append(Stop())
        sequence.append(BasicAction(duration: 0.5))
        
        sequence.append(Down(duration: 1.4, speed: 0.7))
        sequence.append(Stop())
        sequence.append(BasicAction(duration: 0.5))
        
        sequence.append(Front(duration: 2.8, speed: 0.3))
        sequence.append(Up(duration: 1.4, speed: 0.3))
        sequence.append(LookUnder(duration: 0.5))
        sequence.append(BasicAction(duration: 1.5))
        
        if let previewer1 = prev1 {
            sequence.append(PictureAction(imageView: extractedFrameImageView2, previewer: previewer1))
        }

        sparkMovementManager = SparkActionManager(sequence: sequence)
        sparkMovementManager?.playSequence()
    }
    
    @IBAction func exo2Handler(_ sender: Any) {
        sequence = []
        let circlePoints = drawCircle(radius: 0.5)
        for point in circlePoints {
            sequence.append(CircleMove(durationInSec: 0.2, stickPos: point))
        }
        sparkMovementManager = SparkActionManager(sequence: sequence)
        sparkMovementManager?.playSequence()
    }
    
    func landing(){
       print("landing")
       if let mySpark = DJISDKManager.product() as? DJIAircraft {
           if let flightController = mySpark.flightController {
               flightController.startLanding(completion: { (err) in
                   print(err.debugDescription)
               })
           }
       }
    }
    
    @IBAction func takeOff(_ sender: Any) {
       if let mySpark = DJISDKManager.product() as? DJIAircraft {
          if let flightController = mySpark.flightController {
              flightController.startTakeoff(completion: { (err) in
                  print(err.debugDescription)
              })
          }
    }}
              
    func stop() {
       print("Stop")
       sparkMovementManager?.stopSequence()
       if let mySpark = DJISDKManager.product() as? DJIAircraft {
           mySpark.mobileRemoteController?.leftStickVertical = 0.0
           mySpark.mobileRemoteController?.leftStickHorizontal = 0.0
           mySpark.mobileRemoteController?.rightStickHorizontal = 0.0
           mySpark.mobileRemoteController?.rightStickVertical = 0.0
       }
    }
    
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let _ = DJISDKManager.product() {
            if let camera = self.getCamera(){
                camera.delegate = self
                self.setupVideoPreview()
            }
            
            GimbalManager.shared.setup(withDuration: 1.0, defaultPitch: -28.0)
        }
    }

   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func lookFront() {
        GimbalManager.shared.lookFront()
    }
    
    func lookUnder() {
        GimbalManager.shared.lookUnder()
    }
    
    func getCamera() -> DJICamera? {
        // Check if it's an aircraft
        if let mySpark = DJISDKManager.product() as? DJIAircraft {
             return mySpark.camera
        }
        
        return nil
    }
    
    func setupVideoPreview() {
        // Prev1 est de type VideoPreviewer
        // Camera view est une view liée depuis le storyboard
        prev1?.setView(self.cameraView)

        if let _ = DJISDKManager.product(){
            let video = DJISDKManager.videoFeeder()
            DJISDKManager.videoFeeder()?.primaryVideoFeed.add(self, with: nil)
        }
        prev1?.start()
        //VideoPreviewer.instance().start()
    }
    
    func resetVideoPreview() {
        prev1?.unSetView()
        DJISDKManager.videoFeeder()?.primaryVideoFeed.remove(self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let camera = self.getCamera() {
            camera.delegate = nil
        }
        self.resetVideoPreview()
    }
}

extension Exo1ViewController:DJIVideoFeedListener {
    func videoFeed(_ videoFeed: DJIVideoFeed, didUpdateVideoData videoData: Data) {
        //print([UInt8](videoData).count)
        videoData.withUnsafeBytes { (bytes:UnsafePointer<UInt8>) in
            prev1?.push(UnsafeMutablePointer(mutating: bytes), length: Int32(videoData.count))
        }
    }
}

extension Exo1ViewController:DJISDKManagerDelegate {
    func appRegisteredWithError(_ error: Error?) {
        
    }
}

extension Exo1ViewController:DJICameraDelegate {
    
}



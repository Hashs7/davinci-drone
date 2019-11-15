//
//  CompassViewController.swift
//  SparkPerso
//
//  Created by AL on 14/01/2018.
//  Copyright © 2018 AlbanPerli. All rights reserved.
//

import UIKit
import DJISDK
import VideoPreviewer

class CalibrationAndHeadingViewController: UIViewController {

    var timer:Timer? = nil
    var sparkMovementManager: SparkActionManager? = nil
    @IBOutlet weak var extractedFrameImageView: UIImageView!

    
    let locationDelegate = LocationDelegate()
    let locationManager: CLLocationManager = {
        $0.requestWhenInUseAuthorization()
        $0.desiredAccuracy = kCLLocationAccuracyBest
        $0.startUpdatingLocation()
        $0.startUpdatingHeading()
        return $0
    }(CLLocationManager())
    
    @IBOutlet weak var phoneHeadingImageView: UIImageView!
    
    @IBOutlet weak var sparkHeadingImageView: UIImageView!
    
    let prev1 = VideoPreviewer()
    @IBOutlet weak var cameraView: UIView!
    
    
    @IBOutlet weak var socketStatus: UILabel!
    @IBOutlet weak var combinationText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SocketIOManager.instance.connect { result in
             self.socketStatus.text = result
        }
        SocketIOManager.instance.listenToChannel(channel: "droneCombination") { (combination) in
            if let combi = combination {
                self.combinationText.text = combi.joined(separator:",")
            }
            
        }
    }
    
    @IBAction func figure1Handler(_ sender: Any) {
        SocketIOManager.instance.emitValue("1", toChannel: SocketChannels.detectSymbol)
    }
    
    @IBAction func figure2Handler(_ sender: Any) {
        SocketIOManager.instance.emitValue("2", toChannel: SocketChannels.detectSymbol)
    }
    
    @IBAction func figure3Handler(_ sender: Any) {
        SocketIOManager.instance.emitValue("3", toChannel: SocketChannels.detectSymbol)
    }
    
    @IBAction func figure4Handler(_ sender: Any) {
        SocketIOManager.instance.emitValue("4", toChannel: SocketChannels.detectSymbol)
    }
    
    @IBAction func figure5Handler(_ sender: Any) {
        SocketIOManager.instance.emitValue("5", toChannel: SocketChannels.detectSymbol)
    }
    
   

    @IBAction func startButtonClicked(_ sender: UIButton) {
        // ---------------------
        // Spark
        // ---------------------
        if let mySpark = DJISDKManager.product() as? DJIAircraft {
            if let flightController = mySpark.flightController {
                
                if let compass = flightController.compass {
                    print("Calibration state before start: \(compass.calibrationState.rawValue)")
                    compass.startCalibration(completion: { (err) in
                        print(err ?? "Calibration OK")
                        print("Updated calibration state: \(compass.calibrationState.rawValue)")
                        
                        self.timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { (t) in
                            self.readHeading()
                        })
                        
                    })
                }
            }
        }
        
        
        
        // ---------------------
        // iOS
        // ---------------------
        var sequence = [BasicAction]()
        var isCentered = false;
        locationManager.delegate = locationDelegate
        
        locationDelegate.headingCallback = { heading in
            print("Callback")
            UIView.animate(withDuration: 0.5) {
                self.phoneHeadingImageView.transform = CGAffineTransform(rotationAngle: CGFloat(heading).degreesToRadians)
            }
            
            while !isCentered {
                let normalHeading = (heading + 44).truncatingRemainder(dividingBy: 360)
                print("iOS \(CGFloat(normalHeading))")
                if normalHeading < 176 {
                     sequence.append(RotateRight(duration: 0.3, speed: 0.2))
                    print("go to right")
                } else if normalHeading > 184 {
                    print("go to left")
                    sequence.append(RotateLeft(duration: 0.3, speed: 0.2))
                } else {
                    isCentered = true
                    print("center")
                }
                self.sparkMovementManager = SparkActionManager(sequence: sequence)
                self.sparkMovementManager?.playSequence()
            }
        }
        locationManager.startUpdatingHeading()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        timer?.invalidate()
        timer = nil
        if let _ = DJISDKManager.product() {
            if let camera = self.getCamera(){
                camera.delegate = self
                self.setupVideoPreview()
            }
            
            GimbalManager.shared.setup(withDuration: 1.0, defaultPitch: -28.0)
            
        }
    }
    
    @IBAction func startStopCameraButtonClicked(_ sender: UIButton) {
          self.prev1?.snapshotPreview({ (image) in
              if let img = image {
                  let detector: CIDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])!
                  let ciImage: CIImage =  CIImage(image: img)!
                  let features = detector.features(in: ciImage)
                  for feature in features as! [CIQRCodeFeature] {
                      print(feature.bounds)
                      print("feature.bounds \(feature.bounds)")
                      
                      let topRightX = feature.topRight.x / 1000
                      let topLeftX = feature.topLeft.x / 1000
                      let topLeftY = feature.topLeft.y / 800
                      let bottomLeftY = feature.bottomLeft.y / 800
                      let center = CGPoint(x: 0.5, y: 0.43)
                      
                      let x = CGFloat(((topRightX - topLeftX) / 2) + topLeftX)
                      let y = CGFloat(((topLeftY - bottomLeftY) / 2) + topLeftY)
                      let codePosition = CGPoint(x: x, y: y)
                      
                      let gap = CGFloat(0.1)
                      let centerRect = CGRect(x: 0.5 - gap, y: 0.43 - gap, width: gap, height: gap)
                      
                      if !centerRect.contains(codePosition) {
                          var sequence = [BasicAction]()
                          if center.x > codePosition.x {
                              print("à gauche")
                              sequence.append(Left(duration: 0.3, speed: 0.2))
                          } else {
                              print("à droite")
                              sequence.append(Right(duration: 0.3, speed: 0.2))
                          }
                          if center.y > codePosition.y {
                              print("en bas")
                              sequence.append(Back(duration: 0.3, speed: 0.2))
                          } else {
                              print("en haut")
                              sequence.append(Front(duration: 0.3, speed: 0.2))
                          }
                          
                          self.sparkMovementManager = SparkActionManager(sequence: sequence)
                          self.sparkMovementManager?.playSequence()
                      } else {
                          print("c'est centré")
                      }
                      
                      print("qr position \(codePosition)")
                  }
              }
          })
        
      }
    
    
    func resetVideoPreview() {
           prev1?.unSetView()
           //prev2?.unSetView()
           DJISDKManager.videoFeeder()?.primaryVideoFeed.remove(self)
           
       }

       override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           if let camera = self.getCamera() {
               camera.delegate = nil
           }
           self.resetVideoPreview()
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
        /*
        // ...
        // plus loin
        // ...
        // ReceivedData est l'équivalent de ton callBack de reception
        WebSocketManager.shared.receivedData{ data in
            // On extrait les bytes de data sous la forme d'un pointeur sur UInt8
            data.withUnsafeBytes { (bytes:UnsafePointer<UInt8>) in
                // On push ces fameux bytes dans la vue
                prev1?.push(UnsafeMutablePointer(mutating: bytes), length: Int32(data.count))
            }
        }
        */
        
        
        //prev2?.setView(self.camera2View)
        //VideoPreviewer.instance().setView(self.cameraView)
        if let _ = DJISDKManager.product(){
            let video = DJISDKManager.videoFeeder()
            
            DJISDKManager.videoFeeder()?.primaryVideoFeed.add(self, with: nil)
        }
        prev1?.start()
        //prev2?.start()
        //VideoPreviewer.instance().start()
    }
    
    
    
    func readHeading() {
        if let heading = (DJISDKManager.product() as? DJIAircraft)?.flightController?.compass?.heading {
            UIView.animate(withDuration: 0.5) {
                self.sparkHeadingImageView.transform = CGAffineTransform(rotationAngle: CGFloat(heading).degreesToRadians)
            }
            print("Spark: \(CGFloat(heading))")
            /*136.55
            140 max   134 min*/
        }
        
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// Useful tools... ;-)
extension CalibrationAndHeadingViewController {
    func orientationAdjustment() -> CGFloat {
        let isFaceDown: Bool = {
            switch UIDevice.current.orientation {
            case .faceDown: return true
            default: return false
            }
        }()
        
        let adjAngle: CGFloat = {
            switch UIApplication.shared.statusBarOrientation {
            case .landscapeLeft:  return 90
            case .landscapeRight: return -90
            case .portrait, .unknown: return 0
            case .portraitUpsideDown: return isFaceDown ? 180 : -180
            }
        }()
        return adjAngle
    }
}



extension Float {
    var degreesToRadians: Float { return self * .pi / 180 }
    var radiansToDegrees: Float { return self * 180 / .pi }
}

extension CGFloat {
    var degreesToRadians: CGFloat { return self * .pi / 180 }
    var radiansToDegrees: CGFloat { return self * 180 / .pi }
}


extension CalibrationAndHeadingViewController:DJIVideoFeedListener {
    func videoFeed(_ videoFeed: DJIVideoFeed, didUpdateVideoData videoData: Data) {
        //print([UInt8](videoData).count)
        videoData.withUnsafeBytes { (bytes:UnsafePointer<UInt8>) in
            prev1?.push(UnsafeMutablePointer(mutating: bytes), length: Int32(videoData.count))
            //prev2?.push(UnsafeMutablePointer(mutating: bytes), length: Int32(videoData.count))
        }
        
    }

}

extension CalibrationAndHeadingViewController:DJISDKManagerDelegate {
    func appRegisteredWithError(_ error: Error?) {
        
    }
    
    
}

extension CalibrationAndHeadingViewController:DJICameraDelegate {
    
}


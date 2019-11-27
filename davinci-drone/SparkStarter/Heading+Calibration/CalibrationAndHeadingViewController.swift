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
    
    var isCenteredRotation = false;
    var isCenteredQR = false;
    
    var sparkMovementManager: SparkActionManager? = nil
    var sequence = [BasicAction]()
    
    var timer:Timer? = nil
    @IBOutlet weak var extractedFrameImageView: UIImageView!
    
    // Properties
    let ptManager = PTManager.instance
    let imagePicker = UIImagePickerController()
    
    
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
        
        
        ptManager.delegate = self
        ptManager.connect(portNumber: PORT_NUMBER)
        //initSockets()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //USBBridge.shared.disconnect()
    }
    
    
    @IBAction func takeOffCalibrateButtonClicked(_ sender: Any) {
        takeOff()
        delay(7) {
            var sequence: [BasicAction] = [Down(duration: 1.6, speed: 0.5)]
            self.sparkMovementManager = SparkActionManager(sequence: sequence)
            self.sparkMovementManager?.playSequence()
        }
        delay(9) {
            self.calibrate()
        }
    }
    
    func takeOff(){
        if let mySpark = DJISDKManager.product() as? DJIAircraft {
            if let flightController = mySpark.flightController {
                flightController.startTakeoff(completion: { (err) in
                    print(err.debugDescription)
                    
                })
            }
        }
    }
    
    // MARK: - START CALIBRATION
    func calibrate() {
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
                        GimbalManager.shared.lookUnder()
                        
                        self.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { (t) in
                            if(!self.isCenteredRotation){
                                self.readHeading()
                            }
                            
                        })
                        
                    })
                }
            }
        }
        
        locationManager.delegate = locationDelegate
        locationDelegate.headingCallback = { heading in
            UIView.animate(withDuration: 0.5) {
                self.phoneHeadingImageView.transform = CGAffineTransform(rotationAngle: CGFloat(heading).degreesToRadians)
            }
        }
        locationManager.startUpdatingHeading()
    }
    
    @IBAction func printHeading(_ sender: Any) {
        if let heading = (DJISDKManager.product() as? DJIAircraft)?.flightController?.compass?.heading {
                   print("Base heading \(heading+180)")
                   UIView.animate(withDuration: 0.5) {
                       self.sparkHeadingImageView.transform = CGAffineTransform(rotationAngle: CGFloat(heading).degreesToRadians)
                   }
               }
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
    
    @IBAction func printInfosClick(_ sender: Any) {
        self.prev1?.snapshotPreview({ (image) in
            if let img = image {
                print(img.size)
                let detector: CIDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])!
                let ciImage: CIImage =  CIImage(image: img)!
                let features = detector.features(in: ciImage)
                for feature in features as! [CIQRCodeFeature] {
                    print("\(feature.bounds): Bounds")
                    
                    print("\(feature.topRight.x): feature:topRightX")
                    print("\(feature.topLeft.x): feature:topLeftX")
                    print("\(feature.topLeft.y): featuretopLeftY")
                    print("\(feature.bottomLeft.y): feature:bottomLeftY")
                    
                    let topRightX = feature.topRight.x / 1000
                    let topLeftX = feature.topLeft.x / 1000
                    let topLeftY = feature.topLeft.y / 800
                    let bottomLeftY = feature.bottomLeft.y / 800
                    

                    print("\(topRightX): topRightX")
                    print("\(topLeftX): topLeftX")
                    print("\(topLeftY): topLeftY")
                    print("\(bottomLeftY): bottomLeftY")
                    
                    
                }
                
            }
            
        })
        
    }
    
    func calibrateWithQR() {
        self.prev1?.snapshotPreview({ (image) in
            if let img = image {
                print(img.size)
                let detector: CIDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])!
                let ciImage: CIImage =  CIImage(image: img)!
                let features = detector.features(in: ciImage)
                for feature in features as! [CIQRCodeFeature] {
                    print(feature.bounds)
                    print("feature.bounds \(feature.bounds)")
                    
                    print(features)
                    
                    let topRightX = feature.topRight.x / 1000
                    let topLeftX = feature.topLeft.x / 1000
                    let topLeftY = feature.topLeft.y / 800
                    let bottomLeftY = feature.bottomLeft.y / 800
                    
                    print(topRightX)
                    
                    let center = CGPoint(x: 0.5, y: 0.57)
                    
                    let x = CGFloat(((topRightX - topLeftX) / 2) + topLeftX)
                    let y = CGFloat(((topLeftY - bottomLeftY) / 2) + topLeftY)
                    let codePosition = CGPoint(x: x, y: y)
                    
                    let gap = CGFloat(0.16)
                    let centerRect = CGRect(x: 0.5 - (gap/2), y: 0.52 - (gap/2), width: gap, height: gap)
                    var sequence = [BasicAction]()
                    
                    if !centerRect.contains(codePosition) {
                        
                        if center.x > codePosition.x {
                            sequence.append(Left(duration: 0.3, speed: 0.1))
                        } else {
                            sequence.append(Right(duration: 0.3, speed: 0.1))
                        }
                        if center.y > codePosition.y {
                            sequence.append(Back(duration: 0.3, speed: 0.1))
                        } else {
                            sequence.append(Front(duration: 0.3, speed: 0.1))
                        }
                        
                        self.sparkMovementManager = SparkActionManager(sequence: sequence)
                        self.sparkMovementManager?.playSequence()
                    } else {
                        print("c'est centré\(codePosition)")
                        self.isCenteredQR = true;
                        
                        sequence.append(BasicAction(duration: 1.0))
                        //sequence.append(Front(duration: 2.2, speed: 0.2))
                        sequence.append(Stop())
                        sequence.append(BasicAction(duration: 1.0))
                        sequence.append(Down(duration: 0.7, speed: 0.5))
                        self.sparkMovementManager = SparkActionManager(sequence: sequence)
                        self.sparkMovementManager?.playSequence()
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
        
        prev1?.setView(self.cameraView)
        if let _ = DJISDKManager.product(){
            let video = DJISDKManager.videoFeeder()
            
            DJISDKManager.videoFeeder()?.primaryVideoFeed.add(self, with: nil)
        }
        prev1?.start()
        
    }
    
    
    
    
    func readHeading() {
        if let heading = (DJISDKManager.product() as? DJIAircraft)?.flightController?.compass?.heading {
            print("Base heading \(heading+180)")
            UIView.animate(withDuration: 0.5) {
                self.sparkHeadingImageView.transform = CGAffineTransform(rotationAngle: CGFloat(heading).degreesToRadians)
            }
            rotateToCenter(heading: heading)
        }
    }
    
    func moveToQR(){
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (t) in
            if(!self.isCenteredQR){
                self.calibrateWithQR()
            } else {
                self.timer?.invalidate()
                self.timer = nil
            }
        })
    }
    
    func rotateToCenter(heading:Double){
        var sequence = [BasicAction]()
        let headingAdd = heading + 180
        if headingAdd > 78 && headingAdd < 79 {
            self.isCenteredRotation = true
            print("center")
            self.moveToQR()
        }
        else if headingAdd < 78 || headingAdd > 250 {
            sequence.append(RotateRight(duration: 0.2, speed: 0.2))
        } else if headingAdd > 79 || headingAdd < 250 {
            sequence.append(RotateLeft(duration: 0.2, speed: 0.2))
        }
        
        self.sparkMovementManager = SparkActionManager(sequence: sequence)
        self.sparkMovementManager?.playSequence()
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



extension CalibrationAndHeadingViewController: PTManagerDelegate {
    
    func peertalk(shouldAcceptDataOfType type: UInt32) -> Bool {
        return true
    }
    
    func peertalk(didReceiveData data: Data, ofType type: UInt32) {
        
        if type == PTType.string.rawValue {
            let string = data.convert() as! String
            print("string Received: \(string)")
            
            let decoder = JSONDecoder()
            let socketData = try! decoder.decode(SocketDataDecode.self, from: string.data(using: .utf8)!)
            switch socketData.channel {
            case "drone_start":
                print("Drone Start")
                break
            case "drone_stop":
                print("Drone Start")
                break
            case "drone_backhome":
                print("drone_backhome", socketData.data)
                break
            case "drone_combination":
                print("drone_combination", socketData.data)
                break
            default:
                break
            }
            print("datas received", socketData.data)
            
            //let data = String(decoding: string, as: UTF8.self)
            //print(data)
            // self.label.text = "\(count)"
            /*if let values = SocketData.map(JSONString: string) {
             print("SkocketData \(values.channel) \(values.data)")
             }*/
        }
    }
    
    func peertalk(didChangeConnection connected: Bool) {
        print("Connection: \(connected)")
        //self.statusLabel.text = connected ? "Connected" : "Disconnected"
    }
    
}

struct SocketDataDecode: Decodable {
    let channel: String
    let data: [String]
}


struct SocketDataCodable: Codable {
    let channel: String
    let data: String
}

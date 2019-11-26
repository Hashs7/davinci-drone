//
//  CameraViewController.swift
//  SparkPerso
//
//  Created by AL on 14/01/2018.
//  Copyright © 2018 AlbanPerli. All rights reserved.
//

import UIKit
import DJISDK
import VideoPreviewer
import CoreML
import Vision
import ImageIO


class CameraViewController: UIViewController {
    
    @IBOutlet weak var extractedFrameImageView: UIImageView!
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var classificationLabel: UILabel!
    @IBOutlet weak var pictureName: UITextField!
    
    var sparkMovementManager: SparkActionManager? = nil
    var symbolManager: SymbolManager? = nil

    
    let prev1 = VideoPreviewer()
    @IBOutlet weak var cameraView: UIView!
    var pathLayer: CALayer?
    var currentImage: UIImage?
    var isSaved: Bool = false
    var startSequence: Bool = false

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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
    
    @IBAction func lookFront(_ sender: Any) {
        GimbalManager.shared.lookFront()
    }
    
    @IBAction func lookUnder(_ sender: Any) {
        GimbalManager.shared.lookUnder()
    }
    
    @IBAction func stopHandler(_ sender: Any) {
        print("Stop")
        sparkMovementManager?.stopSequence()
        if let mySpark = DJISDKManager.product() as? DJIAircraft {
            mySpark.mobileRemoteController?.leftStickVertical = 0.0
            mySpark.mobileRemoteController?.leftStickHorizontal = 0.0
            mySpark.mobileRemoteController?.rightStickHorizontal = 0.0
            mySpark.mobileRemoteController?.rightStickVertical = 0.0
        }
    }
    
    
    
    @IBAction func startSequenceButtonClicked(_ sender: Any) {
        startSequence = true
        detectSymbol()
    }
    
    func detectSymbol(){
        isSaved = false
              self.prev1?.snapshotThumnnail { image in
                  if let img = image {
                      self.currentImage = img
                      let resoImg = img.resized(to: CGSize(width: 480/2, height: 360/2))
                      let croppedImg = resoImg.cropToBounds(width: 360/2, height: 360/2)
                      self.extractedFrameImageView.image = croppedImg
                      
                      
                      let cgOrientation = CGImagePropertyOrientation(img.imageOrientation)
                      // Fire off request based on URL of chosen photo.
                      guard let cgImage = img.cgImage else {
                          return
                      }
                      
                      let imageRequestHandler = VNImageRequestHandler(cgImage: cgImage,
                                                                      orientation: cgOrientation,
                                                                      options: [:])
                      
                      let requests: [VNRequest] = [self.rectangleDetectionRequest]
                      
                      
                      DispatchQueue.global(qos: .userInitiated).async {
                          do {
                              try imageRequestHandler.perform(requests)
                          } catch let error as NSError {
                              print("Failed to perform image request: \(error)")
                              return
                          }
                      }
                  }
              }
    }
    
    
    @IBAction func startStopCameraButtonClicked(_ sender: UIButton) {
        isSaved = true
        self.prev1?.snapshotPreview({ (image) in
            if let img = image {
                self.currentImage = img
                // Crop image in square and lower resolution
                let resoImg = img.resized(to: CGSize(width: 480/2, height: 360/2))
                let croppedImg = resoImg.cropToBounds(width: 360/2, height: 360/2)
                self.extractedFrameImageView.image = croppedImg
                print(resoImg.size)
                
                let cgOrientation = CGImagePropertyOrientation(img.imageOrientation)
                // Fire off request based on URL of chosen photo.
                guard let cgImage = img.cgImage else {
                    return
                }
                
                let imageRequestHandler = VNImageRequestHandler(cgImage: cgImage,
                                                                orientation: cgOrientation,
                                                                options: [:])
                
                let requests: [VNRequest] = [self.rectangleDetectionRequest]
                
                DispatchQueue.global(qos: .userInitiated).async {
                    do {
                        try imageRequestHandler.perform(requests)
                    } catch let error as NSError {
                        print("Failed to perform image request: \(error)")
                        //self.presentAlert("Image Request Failed", error: error)
                        return
                    }
                }
            }
        })
    }
    
    
    
    @IBAction func detectArrowHandler(_ sender: Any) {
        startSequence = false
      detectSymbol()
    }
    
    
    lazy var rectangleDetectionRequest: VNDetectRectanglesRequest = {
        let rectDetectRequest = VNDetectRectanglesRequest(completionHandler: self.handleDetectedRectangles)
        // Customize & configure the request to detect only certain rectangles.
        rectDetectRequest.maximumObservations = 1 // Vision currently supports up to 16.
        rectDetectRequest.minimumConfidence = 0.6 // Be confident.
        rectDetectRequest.minimumAspectRatio = 0.3 // height / width
        rectDetectRequest.minimumSize = 0.6
        
        return rectDetectRequest
    }()
    
    
    
    func handleDetectedRectangles(request: VNRequest?, error: Error?) {
        if let nsError = error as NSError? {
            print("Rectangle Detection Error", nsError)
            //self.presentAlert("Rectangle Detection Error", error: nsError)
            return
        }
        
        if let results = request?.results as? [VNRectangleObservation] {
            print("requestSSSS", results)
            for observation in results {
                let bounds = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: self.currentImage!.size)
                let rectBox = boundingBox(forRegionOfInterest: observation.boundingBox, withinImageBounds: bounds)
                
                let newRectangle = CGRect(x: rectBox.origin.x,y: rectBox.origin.y-rectBox.size.height,width: rectBox.size.width,height: rectBox.size.height)
                //let rectLayer = shapeLayer(color: .blue, frame: rectBox)
                
                var symbolCropped = self.currentImage!.croppedWithRect(boundingBox: newRectangle);

                DispatchQueue.main.async {
                    self.extractedFrameImageView.image = symbolCropped
                    if(self.isSaved){
                        if let symbol = symbolCropped,
                            let dataImg = symbol.pngData() {
                            let strId = UUID().uuidString
                            let dir = getDocumentsDirectory()
                            let imgName = self.pictureName.text ?? "picture"
                            let imgUrl = dir.appendingPathComponent("\(imgName)-\(strId).png")
                            try! dataImg.write(to: imgUrl)
                            
                        }
                    } else {
                        DispatchQueue.global(qos: .userInitiated).async {
                            if let symbol = symbolCropped{
                                
                                guard let ciImage = CIImage(image: symbol) else { fatalError("Unable to create \(CIImage.self) from \(symbol).") }
                                
                                let orientation = CGImagePropertyOrientation(symbol.imageOrientation)
                                
                                let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
                                do {
                                    try handler.perform([self.classificationRequest])
                                } catch {
        
                                    print("Failed to perform classification.\n\(error.localizedDescription)")
                                }
                            }
                        }
                        
                    }
                }
            }
            
        } 

    }
    
    
    @IBAction func captureModeValueChanged(_ sender: UISegmentedControl) {
        
    }
  

    
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            let model = try VNCoreMLModel(for: SymbolClassifierV5().model)
            
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            })
            //request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()
    
    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                self.classificationLabel.text = "Unable to classify image.\n\(error!.localizedDescription)"
                return
            }
            // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
            let classifications = results as! [VNClassificationObservation]
            
            if classifications.isEmpty {
                self.classificationLabel.text = "Nothing recognized."
            } else {
                // Display top classifications ranked by confidence in the UI.
                let topClassifications = classifications.prefix(2)
                let descriptions = topClassifications.map { classification in
                    // Formats the classification for display; e.g. "(0.37) cliff, drop, drop-off".
                    return String(format: "  (%.2f) %@", classification.confidence, classification.identifier)
                }
                print(descriptions.joined(separator: "\n"))
                self.classificationLabel.text = "Classification:\n" + descriptions.joined(separator: "\n")
                if(self.startSequence){
                    if let symbolMng = self.symbolManager{
                        symbolMng.moveFromSymbol(symbol: descriptions[0])
                        print(descriptions)
                    }
                }
            }
        }
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
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
}

extension CameraViewController:DJIVideoFeedListener {
    func videoFeed(_ videoFeed: DJIVideoFeed, didUpdateVideoData videoData: Data) {
        //print([UInt8](videoData).count)
        videoData.withUnsafeBytes { (bytes:UnsafePointer<UInt8>) in
            prev1?.push(UnsafeMutablePointer(mutating: bytes), length: Int32(videoData.count))
            //prev2?.push(UnsafeMutablePointer(mutating: bytes), length: Int32(videoData.count))
        }
    }
}

extension CameraViewController:DJISDKManagerDelegate {
    func appRegisteredWithError(_ error: Error?) {
        
    }
}

extension CameraViewController:DJICameraDelegate {
    
}

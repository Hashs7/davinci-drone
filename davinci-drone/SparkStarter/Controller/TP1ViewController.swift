//
//  TP1ViewController.swift
//  SparkPerso
//
//  Created by Sébastien Hernoux on 17/10/2019.
//  Copyright © 2019 AlbanPerli. All rights reserved.
//

import UIKit
import DJISDK

class TP1ViewController: UIViewController {
    var sparkMovementManager: SparkMovementManager? = nil
    var sequence = [BasicMove]() {
        didSet {
            DispatchQueue.main.async {
                self.displaySequence()
            }
        }
    }
    @IBOutlet weak var sequenceView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func stopBtnHandler(_ sender: Any) {
        stop()
    }
    
    @IBAction func startBtnHandler(_ sender: Any) {
        print("Start")
        sparkMovementManager?.playSequence()
    }
    
    @IBAction func rotateLeftHandler(_ sender: Any) {
        self.askForDurationAndSpeed { (speed, duration) in
            self.sequence.append(RotateLeft(duration: duration, speed: speed))
        }
    }
    
    @IBAction func frontHandler(_ sender: Any) {
        self.askForDurationAndSpeed { (speed, duration) in
            self.sequence.append(Front(duration: duration, speed: speed))
        }
    }
    @IBAction func backHandler(_ sender: Any) {
        self.askForDurationAndSpeed { (speed, duration) in
            self.sequence.append(Back(duration: duration, speed: speed))
        }
    }
    
    @IBAction func upHandler(_ sender: Any) {
        self.askForDurationAndSpeed { (speed, duration) in
            self.sequence.append(Up(duration: duration, speed: speed))
        }
    }
    
    
    @IBAction func downHandler(_ sender: Any) {
        self.askForDurationAndSpeed { (speed, duration) in
            self.sequence.append(Down(duration: duration, speed: speed))
        }
    }
    
    @IBAction func rotateRightHandler(_ sender: Any) {
        self.askForDurationAndSpeed { (speed, duration) in
            self.sequence.append(RotateLeft(duration: duration, speed: speed))
        }
    }
    
    @IBAction func squareHandler(_ sender: Any) {
        self.sequence += [Front(duration: 1.0, speed: 0.4), RotateRight90(),
                          Front(duration: 1.0, speed: 0.4), RotateRight90(),
                          Front(duration: 1.0, speed: 0.4), RotateRight90(),
                          Front(duration: 1.0, speed: 0.4), RotateRight90()]
    }
    
    @IBAction func circleHandler(_ sender: Any) {
        
    }
    
    @IBAction func clearHandler(_ sender: Any) {
        sparkMovementManager?.clearSequence()
        sequence = []
        sequenceView.text = ""
    }
    
    func displaySequence() {
        sparkMovementManager = SparkMovementManager(sequence: sequence)
        if let desc = sparkMovementManager?.sequenceDescription() {
            sequenceView.text = desc
        }
    }
    
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

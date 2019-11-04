//
//  SpheroTP1ViewController.swift
//  SparkPerso
//
//  Created by Sébastien Hernoux on 18/10/2019.
//  Copyright © 2019 AlbanPerli. All rights reserved.
//

import UIKit

class SpheroTP1ViewController: UIViewController {

    var spheroMovementManager: SpheroMovementManager? = nil
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
        spheroMovementManager?.playSequence()
    }
    @IBAction func rotateLeftHandler(_ sender: Any) {
        sequence.append(SpheroMove(heading: 90.0, duration: 0.0, speed: 0.0))
    }
    
    @IBAction func frontHandler(_ sender: Any) {
        self.askForDurationAndSpeedAndHeading { (speed, duration, heading) in
            self.sequence.append(SpheroMove(heading: Double(heading), duration: duration, speed: speed))
        }
    }
    
    @IBAction func rotateRightHandler(_ sender: Any) {
        sequence.append(SpheroMove(heading: 270.0, duration: 0.0, speed: 0.0))
    }
    
    @IBAction func clearHandler(_ sender: Any) {
        spheroMovementManager?.clearSequence()
        sequence = []
        sequenceView.text = ""
    }
    
    func displaySequence() {
        spheroMovementManager = SpheroMovementManager(sequence: sequence)
        if let desc = spheroMovementManager?.sequenceDescription() {
            sequenceView.text = desc
        }
    }
    
    func stop() {
        print("Stop")
        spheroMovementManager?.stopSequence()
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

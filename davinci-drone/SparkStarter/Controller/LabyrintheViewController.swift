//
//  LabyrintheViewController.swift
//  davinci-drone
//
//  Created by Sébastien Hernoux on 13/11/2019.
//  Copyright © 2019 Sébastien Hernoux. All rights reserved.
//

import UIKit

class LabyrintheViewController: UIViewController {
    
    @IBOutlet weak var socketStatus: UILabel!
    @IBOutlet weak var combinationText: UITextView!
    var sparkMovementManager: SparkActionManager? = nil
    var sequence = [BasicAction]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SocketIOManager.instance.connect { result in
            self.socketStatus.text = result
        }
        SocketIOManager.instance.listenToChannel(channel: "droneCombination") { (combination) in
            if let combi = combination {
                self.combinationText.text = combi.joined(separator:",")
                let sequence = SparkActionManager.createSymbolSequence(sequence: combi)
                print("sequence: \(sequence)")
            }
        }
    }
    
    //WHITE
    @IBAction func figure1Handler(_ sender: Any) {
        //SocketIOManager.instance.emitValue("1", toChannel: SocketChannels.detectSymbol)
        sparkMovementManager?.clearSequence()
        sequence = []
        self.sequence.append(Right(duration: 1.6, speed: 0.2))
        self.sequence.append(Stop())
        self.sequence.append(BasicAction(duration: 2.0))
        self.sequence.append(Right(duration: 1.9, speed: 0.2))
        self.sequence.append(Stop())
        self.sequence.append(BasicAction(duration: 2.0))
        self.sequence.append(Back(duration: 1, speed: 0.2))
        self.sequence.append(Stop())
        self.sequence.append(BasicAction(duration: 2.0))
        self.sparkMovementManager = SparkActionManager(sequence: sequence)
        sparkMovementManager?.playSequence()
    }
    
    //BLUE
    @IBAction func figure2Handler(_ sender: Any) {
        //SocketIOManager.instance.emitValue("2", toChannel: SocketChannels.detectSymbol)
        sparkMovementManager?.clearSequence()
        sequence = []
        self.sequence.append(Right(duration: 2.1, speed: 0.2))
        self.sequence.append(Stop())
        self.sequence.append(BasicAction(duration: 2.0))
        self.sequence.append(Front(duration: 1.5, speed: 0.2))
        self.sequence.append(Stop())
        self.sequence.append(BasicAction(duration: 2.0))
        self.sequence.append(Front(duration: 1.7, speed: 0.2))
        self.sequence.append(Stop())
        self.sequence.append(BasicAction(duration: 2.0))
        self.sparkMovementManager = SparkActionManager(sequence: sequence)
        sparkMovementManager?.playSequence()
    }
    
    //YELLOW
    @IBAction func figure3Handler(_ sender: Any) {
        //SocketIOManager.instance.emitValue("3", toChannel: SocketChannels.detectSymbol)
        sparkMovementManager?.clearSequence()
        sequence = []
        self.sequence.append(Left(duration: 1.5, speed: 0.2))
        self.sequence.append(Stop())
        self.sequence.append(BasicAction(duration: 2.0))
        self.sequence.append(Left(duration: 1.6, speed: 0.2))
        self.sequence.append(Stop())
        self.sequence.append(BasicAction(duration: 2.0))
        self.sequence.append(Left(duration: 1.6, speed: 0.2))
        self.sequence.append(Stop())
        self.sequence.append(BasicAction(duration: 2.0))
        self.sequence.append(Front(duration: 2.1, speed: 0.2))
        self.sparkMovementManager = SparkActionManager(sequence: sequence)

        sparkMovementManager?.playSequence()
    }
    
    //RED
    @IBAction func figure4Handler(_ sender: Any) {
        //SocketIOManager.instance.emitValue("4", toChannel: SocketChannels.detectSymbol)
        sparkMovementManager?.clearSequence()
        sequence = []
        self.sequence.append(Front(duration: 2.2, speed: 0.2))
        self.sequence.append(Stop())
        self.sequence.append(BasicAction(duration: 2.0))
        self.sequence.append(Right(duration: 1.6, speed: 0.2))
        self.sequence.append(Stop())
        self.sequence.append(BasicAction(duration: 2.0))
        self.sequence.append(Right(duration: 1.8, speed: 0.2))
        self.sequence.append(Stop())
        self.sequence.append(BasicAction(duration: 2.0))
        self.sequence.append(Right(duration: 1.9, speed: 0.2))
        self.sequence.append(Stop())
        self.sequence.append(BasicAction(duration: 2.0))
        self.sequence.append(Back(duration: 1.4, speed: 0.2))
        self.sparkMovementManager = SparkActionManager(sequence: sequence)

        sparkMovementManager?.playSequence()
    }
    
    //GREEN
    @IBAction func figure5Handler(_ sender: Any) {
        //SocketIOManager.instance.emitValue("5", toChannel: SocketChannels.detectSymbol)
        sparkMovementManager?.clearSequence()
        sequence = []
        self.sequence.append(Left(duration: 1.4, speed: 0.2))
        self.sequence.append(Stop())
        self.sequence.append(BasicAction(duration: 2.0))
        self.sequence.append(Back(duration: 1.4, speed: 0.2))
        self.sequence.append(Stop())
        self.sequence.append(BasicAction(duration: 2.0))
        self.sequence.append(Back(duration: 1.3, speed: 0.2))
        self.sparkMovementManager = SparkActionManager(sequence: sequence)

        sparkMovementManager?.playSequence()
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

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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

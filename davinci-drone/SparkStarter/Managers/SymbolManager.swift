
class SymbolManager {
    var sparkMovementManager: SparkActionManager? = nil
    
    var sequence = [BasicAction]()
    
    func initSocket(){
        SocketIOManager.instance.connect { result in
            print(result)
        }
        SocketIOManager.instance.listenToChannel(channel: "droneCombination") { (combination) in
            if let combi = combination {
                print(combi.joined(separator:","))
                let sequence = SparkActionManager.createSymbolSequence(sequence: combi)
                print("sequence: \(sequence)")
            }
        }
    }
    
    func moveFromSymbol(symbol:String){
        switch symbol {
        case "blue":
            blueHandler()
        case "white":
            whiteHandler()
        case "yellow":
        yellowHandler()
        case "red":
        redHandler()
        case "green":
        greenHandler()
        default:
            break
        }
    }
    //WHITE
    func whiteHandler() {
        SocketIOManager.instance.emitValue("1", toChannel: SocketChannels.detectSymbol)
        sparkMovementManager?.clearSequence()
        sequence = []
        self.sequence.append(Right(duration: 1.3, speed: 0.2))
        self.sequence.append(Stop())
        self.sequence.append(BasicAction(duration: 1.0))
        self.sequence.append(Right(duration: 1.3, speed: 0.2))
        self.sequence.append(Stop())
        self.sequence.append(BasicAction(duration: 1.0))
        self.sequence.append(Down(duration: 1.3, speed: 0.2))
        self.sequence.append(Stop())
        self.sequence.append(BasicAction(duration: 1.0))
        sparkMovementManager?.playSequence()
    }
    
    //BLUE
    func blueHandler() {
        SocketIOManager.instance.emitValue("2", toChannel: SocketChannels.detectSymbol)
        sparkMovementManager?.clearSequence()
        sequence = []
        self.sequence.append(Right(duration: 1.3, speed: 0.2))
        self.sequence.append(Stop())
        self.sequence.append(BasicAction(duration: 1.0))
        self.sequence.append(Front(duration: 1.3, speed: 0.2))
        self.sequence.append(Stop())
        self.sequence.append(BasicAction(duration: 1.0))
        self.sequence.append(Front(duration: 1.3, speed: 0.2))
        self.sequence.append(Stop())
        self.sequence.append(BasicAction(duration: 1.0))
        sparkMovementManager?.playSequence()
    }
    
    //YELLOW
    func yellowHandler() {
        SocketIOManager.instance.emitValue("3", toChannel: SocketChannels.detectSymbol)
        sparkMovementManager?.clearSequence()
        sequence = []
        self.sequence.append(Left(duration: 1.3, speed: 0.2))
        self.sequence.append(Stop())
        self.sequence.append(BasicAction(duration: 1.0))
        self.sequence.append(Left(duration: 1.3, speed: 0.2))
        self.sequence.append(Stop())
        self.sequence.append(BasicAction(duration: 1.0))
        self.sequence.append(Left(duration: 1.3, speed: 0.2))
        self.sequence.append(Stop())
        self.sequence.append(BasicAction(duration: 1.0))
        self.sequence.append(Front(duration: 1.3, speed: 0.2))
        self.sequence.append(Stop())
        self.sequence.append(BasicAction(duration: 1.0))
        sparkMovementManager?.playSequence()
    }
    
    //RED
    func redHandler() {
        SocketIOManager.instance.emitValue("4", toChannel: SocketChannels.detectSymbol)
        sparkMovementManager?.clearSequence()
        sequence = []
        self.sequence.append(Front(duration: 1.3, speed: 0.2))
        self.sequence.append(Stop())
        self.sequence.append(BasicAction(duration: 1.0))
        self.sequence.append(Right(duration: 1.3, speed: 0.2))
        self.sequence.append(Stop())
        self.sequence.append(BasicAction(duration: 1.0))
        self.sequence.append(Right(duration: 1.3, speed: 0.2))
        self.sequence.append(Stop())
        self.sequence.append(BasicAction(duration: 1.0))
        self.sequence.append(Right(duration: 1.3, speed: 0.2))
        self.sequence.append(Stop())
        self.sequence.append(BasicAction(duration: 1.0))
        self.sequence.append(Down(duration: 1.3, speed: 0.2))
        self.sequence.append(Stop())
        self.sequence.append(BasicAction(duration: 1.0))
        sparkMovementManager?.playSequence()
    }
    
    //GREEN
    func greenHandler() {
        SocketIOManager.instance.emitValue("5", toChannel: SocketChannels.detectSymbol)
        sparkMovementManager?.clearSequence()
        sequence = []
        self.sequence.append(Left(duration: 1.3, speed: 0.2))
        self.sequence.append(Stop())
        self.sequence.append(BasicAction(duration: 1.0))
        self.sequence.append(Down(duration: 1.3, speed: 0.2))
        self.sequence.append(Stop())
        self.sequence.append(BasicAction(duration: 1.0))
        self.sequence.append(Down(duration: 1.3, speed: 0.2))
        self.sequence.append(Stop())
        self.sequence.append(BasicAction(duration: 1.0))
        sparkMovementManager?.playSequence()
    }
}

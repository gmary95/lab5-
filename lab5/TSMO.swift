class TSMO { //об’єкт «система масового обслуговування»
    private var NumChannel, MaxQueue: Int //кількість пристроїв обслуговування
    private var TimeFinServ: [Double] //
    private var StateChannel: [Int] //поточний стан пристроїв
    private var StateQueue: Int //поточний стан черги
    private var Serv: Double
    private var Entry: Bool
    private var Exit: Bool
    private var tmin: Double
    private var minChannel: Int
    private var block: Bool
    
    init(aNum: Int, aMax: Int, aTimeMod: Double, aServ: Double) {
        // в конструкторі об’єкта «система масового обслуговування» задаються // значення кількості пристроїв обслуговування aNum,
        // обмеження на довжину черги aMax,
        // середня тривалість обслуговування aServ,
        // значення часу моделювання aTimeMod
        StateQueue = 0 //початковий стан черги
        MaxQueue = aMax
        NumChannel = aNum
        Serv = aServ
        Entry = false
        Exit = false
        block = false // в початковий момент блокування маршруту відсутнє
        TimeFinServ = Array<Double>(repeating: aTimeMod, count: NumChannel)
        StateChannel = Array<Int>(repeating: 0, count: NumChannel)
        //початковий стан пристроїв - вільний
        tmin = TimeFinServ[0]
        minChannel = 1
        if NumChannel > 1 {
            for i in 1 ... NumChannel {
                if TimeFinServ[i-1] < tmin {
                    tmin = TimeFinServ[i-1]
                    minChannel = i
                }
            }
        } // формувати найближчу подію в СМО
    }
    
    func Seize(at: Double) { // зайняти СМО
        var j: Bool
        var i: Int
        if Entry == true {
            j = false
            i = 1
            while (i <= NumChannel) && (j == false) {
                if StateChannel[i-1] == 0 {
                    j = true
                    SeizeChannel(aChannel: i,at: at)
                    NextTime() // змінити найближчу подію в СМО
                    Entry = false
                } else {
                    i += 1
                }
            }
            if (j == false) && (MaxQueue > 0) {
                StateQueue = StateQueue+1
                Entry = false
                if StateQueue == MaxQueue { block = true}
            }
        }
    }
    
    func Releize(aChannel: Int, aTimeMod: Double, at: Double) {
        //звільнити СМО
        if StateQueue>0 {
            StateQueue = StateQueue-1
            
            if block == true { block = false }
            SeizeChannel(aChannel: aChannel,at: at)
            NextTime()
        } else {
            ReleizeChannel(aChannel: aChannel,aTimeMod: aTimeMod)
            NextTime()
        }
        Exit = true
    }
    
    func GetStateQue() -> Int {
        return StateQueue
    }
    
    func SeizeChannel(aChannel: Int, at: Double) {
        //зайняти пристрій з номером aChannel
        StateChannel[aChannel-1] = 1
        TimeFinServ[aChannel-1] = at + Generator().random(lambda: Serv)
    }
    
    func ReleizeChannel(aChannel: Int, aTimeMod: Double) {
        //звільнити пристрій з номером aChannel
        StateChannel[aChannel-1] = 0
        TimeFinServ[aChannel-1] = aTimeMod
    }
    
    func NextTime() { //запам’ятати найближчу події у СМО
        tmin = TimeFinServ[0]
        minChannel = 1
        if NumChannel > 1 {
            for i in 1 ... NumChannel {
                if TimeFinServ[i-1] < tmin {
                    tmin = TimeFinServ[i-1]
                    minChannel = i
                }
            }
        }
    }
    
    func GetStateChannel(aNum: Int) -> Int {
        return StateChannel[aNum-1]
    }
    
    func SetExit(aEnt: Bool){
        Exit = aEnt
    }
    
    func SetEntry(aEx: Bool){
        Entry = aEx
    }
    
    func GetMinTime() -> Double {
        return tmin
    }
    
    func GetMinChannel() -> Int {
        return minChannel
    }
    
    func GetNumChannel() -> Int {
        return NumChannel
    }
    
    func GetAverLoadChannel() -> Double { //підрахувати середню кількість зайнятих пристроїв
        var sum: Double
        sum = 0
        for i in 1 ... GetNumChannel() {
            sum = sum + Double(StateChannel[i-1])
        }
        return sum
    }
    
    func GetBlock() -> Bool { //повідомити про стан блокування
        return block
    }
}

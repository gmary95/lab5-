class TJoin { //об’єкт «маршрут», що передає вимогу від СМО (EntrySmo) до СМО (ExitSmo)
    private var EntrySmo: TSMO
    private var ExitSmo: TSMO
    private var State: Bool
    private var NumUnServ: Int
    
    init(aSmoEntry: TSMO, aSmoExit: TSMO){
        //у конструкторі об’єкту «маршрут» задаються СМО EntrySmo, з якої вимога ви- ходить,
        // та СМО ExitSmo, до якої вимога надходить
        EntrySmo = aSmoEntry
        ExitSmo = aSmoExit
        State = true
        NumUnServ = 0
    }
    
    func send() { //здійснює передачу вимоги уздовж заданого маршруту
        if GetState() == true {
            EntrySmo.SetExit(false)
            ExitSmo.SetEntry(true)
        } else {
            NumUnServ = NumUnServ+1
        }
    }
    
    func GetState() -> Bool {
        if ExitSmo.GetBlock() == true {
            return false
        } else {
            return true
        }
    }
    
    func GetNumUnServ() -> Int {
        return NumUnServ
    }
}

class TJoinIN { //об’єкт «маршрут входу», що передає вимогу від вхідного потоку до СМО
    private var Entry: TSystEntry
    private var ExitSmo: TSMO
    private var State: Bool
    private var NumUnServ: Int
    init(aEntry: TSystEntry, aSmoExit: TSMO) {
        //у конструкторі задається вхідний потік, з якого вимога виходить,
        // та СМО, до якої вимога надходить
        Entry = aEntry
        ExitSmo = aSmoExit
        State = true
        NumUnServ = 0
    }
    
    func send() {
        if GetState() == true {
            Entry.SetExit(aEnt: false)
            ExitSmo.SetEntry(true)
        } else {
            NumUnServ = NumUnServ+1
        }
    }
    
    func GetState() -> Bool {
        if ExitSmo.GetBlock() == true {
            return false
        } else {
            return true
        }
    }
    
    func GetNumUnServ() -> Int {
        return NumUnServ
    }
}

class TJoinOUT {//об’єкт «маршрут виходу», що передає вимогу із СМО на вихід із мережі МО
    private var EntrySmo: TSMO
    private var State: Bool
    private var NumService: Int
    
    init(aSmoEntry:TSMO) {
        //у конструкторі задається СМО, з якої вимога виходить
        EntrySmo = aSmoEntry
        NumService = 0
        State = true
    }
    
    func send() {
        if State == true {
            EntrySmo.SetExit(false)
            NumService += 1
        }
    }
    
    func GetNumService() -> Int {
        return NumService
    }
}

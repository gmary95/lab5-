class TSystEntry { // об’єкт «вхідний потік вимог»
    private var Exit: Bool
    private var Entry: Bool
    private var Interval: Double //інтервал часу, з яким мають надходити вимоги з вхідного потоку
    private var TimeExit: Double = 0//момент часу, в який вимога має вийти з вхідного потоку
    private var NumArrival: Int = 0//загальна кількість вимог, що створена вхідним потоком вимог
    
    //в конструкторі об’єкта «вхідний потік вимог» задається
    // значення середнього інтервалу часу aInterval, з яким надходять вимоги
    init(aInterval: Double) {
        Entry = true
        Exit = false
        Interval = aInterval
    }
    
    func Arrival (at: Double) {
        TimeExit = at + Generator().random(lambda: Interval)
        //інтервал часу між надходження вимог заданий за експоненціальним законом розподілу
        Exit = true
        NumArrival = NumArrival + 1
    }
    
    func EntryInSyst() {
        Exit = true
        Entry = true
    }
    
    //формує момент часу TimeExit в залежності від поточного моменту часу at procedure EntryInSyst;
    func GetMinTime() -> Double {
        return TimeExit
    }
    
    func GetNumArrival() -> Int {
        return NumArrival
    }
    
    func SetExit(aEnt: Bool) {
        Exit = aEnt
    }
    
    func SetEntry(aEx: Bool) {
        Entry = aEx
    }
}

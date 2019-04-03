class SMO1: TSMO {
    var TimeCurrent: Double
    let MaxQue = 6
    let lamb = 0.2
    var TimeMod: Double
    
    init(TimeCurrent: Double, TimeMod: Double) {
        self.TimeCurrent = TimeCurrent
        self.TimeMod = TimeMod
    }
    //Подія "надходження вимоги до СМО"
    func EventEnter( aDevice: inout Int, aTimeExit: inout Double, aTimeAct: inout Double, aCurQue: inout Int, NumUnServ: inout Int, NumAll: inout Int){
        if aDevice==0 {
            aDevice=1
            aTimeExit=TimeCurrent+Generator().random(lambda: lamb)
        } else if aCurQue < MaxQue {
            aCurQue=aCurQue+1
        } else {
            NumUnServ=NumUnServ+1
        }
        aTimeAct=TimeCurrent+Generator().random(lambda: lamb)
        NumAll=NumAll+1
    }
    //Подія "закінчилась обробка вимоги в каналі СМО"
    func EventExit(aDevice: inout Int, aTimeExit: inout Double, aTimeAct: inout Double, aCurQue: inout Int, NumServ: inout Int){
        NumServ=NumServ+1
        if aCurQue>0 {
            aCurQue=aCurQue-1
            aDevice=1
            aTimeExit=TimeCurrent+Generator().random(lambda: lamb)
        } else {
            aDevice=0
            aTimeExit=TimeMod+1
        }
    }
}

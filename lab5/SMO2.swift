class SMO2 {
    var TimeCurrent: Double
    let MaxQue = 1
    let time = 2.0
    var TimeMod: Double
    
    init(TimeCurrent: Double, TimeMod: Double) {
        self.TimeCurrent = TimeCurrent
    }
    //Подія "надходження вимоги до СМО"
    func EventEnter( aDevice: inout Int, aTimeExit: inout Double, aTimeAct: inout Double, aCurQue: inout Int, NumUnServ: inout Int, NumAll: inout Int){
        if aDevice==0 {
            aDevice=1
            aTimeExit=TimeCurrent+time
        } else if aCurQue < MaxQue {
            aCurQue=aCurQue+1
        } else {
            NumUnServ=NumUnServ+1
        }
        aTimeAct=TimeCurrent+time
        NumAll=NumAll+1
    }
    //Подія "закінчилась обробка вимоги в каналі СМО"
    func EventExit(aDevice: inout Int, aTimeExit: inout Double, aTimeAct: inout Double, aCurQue: inout Int, NumServ: inout Int){
        NumServ=NumServ+1
        if aCurQue>0 {
            aCurQue=aCurQue-1
            aDevice=1
            aTimeExit=TimeCurrent+time
        } else {
            aDevice=0
            aTimeExit=TimeMod+1
        }
    }
}

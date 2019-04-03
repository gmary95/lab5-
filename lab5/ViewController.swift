//
//  ViewController.swift
//  lab5
//
//  Created by Mary Gerina on 3/25/19.
//  Copyright © 2019 Mary Gerina. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var NText: NSTextFieldCell!
    @IBOutlet weak var statisticsTable: NSTableView!
    
    var TimeMod = 0.0
    var t = 0.0
    
    var P: Double?
    var L: Double?
    var Q: Double?
    var T: Double?
    var R: Double?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func startimitation(_ sender: Any) {
        TimeMod = Double(NText.title) ?? 100.0
        TimeCurrent=0
        NumServ=0
        NumUnServ=0
        NumAll=0
        Device=0
        TimeExit = TimeMod+1.0
        TimeAct=0
        min=TimeAct
        sob=1
        CurQue=0
        AverageQueue=0
        AverageDevice=0
        
        while TimeCurrent < TimeMod {
            
        }
        statisticsTable.reloadData()
    }
    
    
    func imitation() {
        var smo: [TSMO]
        var NumSMO: Int
        var systEntry: TSystEntry
        var join: [TJoin]
        var joinIn: [TJoinIN]
        var joinOut: [TJoinOUT]
        var tmin: Double
        var event: Int
        var AverQue,AverDevices: [Double]
        var i: Int
        var prob,choice: Double
        
        let GetTimeMod = TimeMod
        let GetTimeNow = t
        
        NumSMO = 2//кількість СМО
        smo = Array(repeating: TSMO(), count: NumSMO)
        join = Array(repeating: TJoin(aSmoEntry: TSMO()), count: NumSMO - 1)
        AverDevices = Array(repeating: 0.0, count: NumSMO)
        AverQue = Array(repeating: 0.0, count: NumSMO)
        
        prob = 0
        
        //структура мережі масового обслуговування
        systEntry = TSystEntry(aInterval: 0.1) //створення вхідного потоку вимог
        smo[0] = TSMO(5,10,GetTimeMod,1.2) //створення СМО1
        joinIn = [TJoinIN(aEntry: systEntry,aSmoExit: smo[0])]// створення маршруту до СМО1
        smo[1] = TSMO(7,8,GetTimeMod,2) //створення СМО2
        join[0] = TJoin(aSmoEntry: smo[0],aSmoExit: smo[1]) //створення маршруту від СМО1 до СМО2
        joinOut = [TJoinOUT(aSmoEntry: smo[NumSMO-1])] //створення маршруту на вихід системи
        t = 0.0 // початкове значення модельного часу
        while t < GetTimeMod {
            tmin = systEntry.GetMinTime()
            event = 0
            for i in 0 ... NumSMO-1 {
                if smo[i].GetMinTime<tmin {
                    tmin = smo[i].GetMinTime
                    event += 1
                }
            }
            for i in 0 ... NumSMO-1 {
                AverQue[i] = AverQue[i] + ((tmin - t) / GetTimeMod) * smo[i].GetStateQue
                AverDevices[i] = AverDevices[i] + ((tmin - t) / GetTimeMod) * smo[i].GetAverLoadChannel
            }
            t = tmin //просування часу в момент найближчої події
            switch event {
            case 0:
                systEntry.Arrival(at: GetTimeNow)
                joinIn.send()
                smo[0].Seize(GetTimeNow)
                
            case 1:
                smo[0].Releize(smo[0].GetMinChannel,GetTimeMod,GetTimeNow)
                join[0].send()
                smo[1].Seize(GetTimeNow)
                
            case 2:
                smo[1].Releize(smo[1].GetMinChannel,GetTimeMod,GetTimeNow)
                joinOut.send()
            default:
                break
            }
            prob = joinIn.GetNumUnServ()
            for i in 0 ... NumSMO-2 {
                prob = prob + Double(join[i].GetNumUnServ())
            }
            prob = prob / Double(systEntry.GetNumArrival())
            
            //        Edit2.Text:=FloatToStr(GetTimeNow);
            //        Edit3.Text:=FloatToStr(prob);
            //        Edit4.Text:=FloatToStr(joinOut.GetNumService);
            //        Edit5.Text:=IntToStr(systEntry.GetNumArrival);
            //        Edit6.Text:=FloatToStr(AverQue[0]);
            //        Edit7.Text:=FloatToStr(AverDevices[0]);
            //        Edit8.Text:=IntToStr(joinIn.GetNumUnServ);
            //        Edit9.Text:=FloatToStr(AverQue[1]);
            //        Edit10.Text:=FloatToStr(AverDevices[1]);
            //        Edit11.Text:=IntToStr(join[0].GetNumUnServ);
            //        Edit12.Text:=FloatToStr(AverQue[2]);
            //        Edit13.Text:=FloatToStr(AverDevices[2]);
            //        Edit14.Text:=IntToStr(join[1].GetNumUnServ);
        }
    }
    
}

extension ViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return 1
    }
}

extension ViewController: NSTableViewDelegate {
    
    fileprivate enum CellIdentifiersStatisticsTable {
        static let PCell = "PID"
        static let LCell = "LID"
        static let QCell = "QID"
        static let TCell = "TID"
        static let RCell = "RID"
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if tableView == statisticsTable {
            return self.loadStatistics(tableView, viewFor: tableColumn, row: row)
        }
        return nil
    }
    
    
    
    func loadStatistics(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSTableCellView? {
        
        var text: String = ""
        var cellIdentifier: String = ""
        
        if tableColumn == tableView.tableColumns[0] {
            if let p = P {
                text = "\(p.rounded(toPlaces: 6))"
            }
            cellIdentifier = CellIdentifiersStatisticsTable.PCell
        } else if tableColumn == tableView.tableColumns[1] {
            if let l = L {
                text = "\(l.rounded(toPlaces: 6))"
            }
            cellIdentifier = CellIdentifiersStatisticsTable.LCell
        } else if tableColumn == tableView.tableColumns[2] {
            if let q = Q {
                text = "\(q.rounded(toPlaces: 6))"
            }
            cellIdentifier = CellIdentifiersStatisticsTable.QCell
        } else if tableColumn == tableView.tableColumns[3] {
            if let t = T {
                text = "\(t.rounded(toPlaces: 6))"
            }
            cellIdentifier = CellIdentifiersStatisticsTable.TCell
        } else if tableColumn == tableView.tableColumns[4] {
            if let r = R {
                text = "\(r.rounded(toPlaces: 6))"
            }
            cellIdentifier = CellIdentifiersStatisticsTable.RCell
        }
        
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        return nil
    }
}



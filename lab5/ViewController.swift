//
//  ViewController.swift
//  lab5
//
//  Created by Mary Gerina on 3/25/19.
//  Copyright © 2019 Mary Gerina. All rights reserved.
//

import Cocoa
import Foundation

class ViewController: NSViewController {
    @IBOutlet weak var NText: NSTextFieldCell!
    @IBOutlet weak var label: NSTextFieldCell!
    
    
    
    let maxL=6
    var Tmod=2000.0
    let Tobr1=0.2
    let Tobr2=0.5
    let lmd=0.1
    
    let generator = Generator()
    
    var a = 0.0
    var tmin = 0.0
    var tp = 0.0
    var Ch1 = 0.0
    var Ch2 = 0.0
    var t = 0.0
    var t11 = 0.0
    var t12 = 0.0
    var t2 = 0.0
    var t0 = 0.0
    var ss1 = 0.0
    var ss2 = 0.0
    var r11 = 0.0
    var r12 = 0.0
    var r2 = 0.0
    var L1 = 0
    var L2 = 0
    var i = 0
    var n = 0
    var z11 = 0
    var z12 = 0
    var z2 = 0
    var sob = 0
    var Notk = 0
    var Nobr = 0
    
    var P: Double?
    var L: Double?
    var Q: Double?
    var T: Double?
    var R: Double?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func startimitation(_ sender: Any) {
        Tmod = Double(NText.title) ?? 100.0
        
        imitation()
    }
    
    
    func  Naubl_podia() {
        tmin = t0
        sob = 1
        if t11<tmin {
            tmin = t11
            sob = 2
        }
        if t12<tmin {
            tmin = t12
            sob = 2
        }
        if t2<tmin {
            tmin = t2
            sob = 3
        }
    }
    
    func Vxod_v_SMO1() {
        if z11 == 0 {
            z11 = 1
            ss1 = generator.random(lambda: Tobr1)
            t11 = t + ss1
            r11 = r11 + ss1
        } else if z12 == 0 {
            z12 = 1
            ss1 = generator.random(lambda: Tobr1)
            t12 = t + ss1
            r12 = r12 + ss1
        } else if L1 < maxL {
            L1 = L1+1
        } else {
            Notk = Notk+1
        }
        t0 = t + generator.random(lambda: lmd)
    }
    
    func Vuxod_iz_SMO1() {
        if (t == t11) {
            z2 = 1
            ss1 = generator.random(lambda: Tobr1)
            t2 = t+ss2
            r2 = r2+ss2
            if L1 > 0 {
                ss1 = generator.random(lambda: Tobr1)
                t11 = t+ss1
                L1 = L1-1
            } else {
                z11 = 0
                t11 = Double(Tmod)
            }
        } else {
            L2 = L2+1
        }
        
        if (t == t12) {
            z2 = 1
            ss2 = generator.random(lambda: Tobr2)
            t2 = t+ss2
            r2 = r2+ss2
            if L1 > 0 {
                ss1 = generator.random(lambda: Tobr1)
                t12 = t+ss1
                L1 = L1-1
            } else {
                z12 = 0
                t12 = Double(Tmod)
            }
        } else  {
            L2 = L2+1
        }
    }
    
    func Vuxid_iz_SMO2() {
        var b:Double
        b = Double.random(in: 0...1)
        
        if b < 0.5 {
            z2 = 0
            t2 = Double(Tmod)
            Vuxod_iz_SMO1()
        } else if L2 > 0 {
            ss2 = generator.random(lambda: Tobr2)
            t2 = t+ss2
            L2 = L2-1
            Nobr += 1
        } else {
            z2 = 0
            t2 = Double(Tmod)
            Nobr += 1
        }
        
    }
    
    func imitation() {
        t = 0
        t0 = 2
        t11 = Double(Tmod)
        t12 = Double(Tmod)
        t2 = Double(Tmod)
        z11 = 0
        z12 = 0
        z2 = 0
        L1 = 0
        L2 = 0
        Ch1 = 0
        Ch2 = 0
        tp = 0
        tmin = generator.random(lambda: lmd)
        ss2 = generator.random(lambda: Tobr2)
        ss1 = generator.random(lambda: Tobr1)
        t = tmin
        Nobr = 0
        Notk = 0
        while (t < Tmod) {
            Naubl_podia()
            tp = t
            t = tmin
            n += 1
            Ch1 = Ch1+Double(L1)*(t-tp)
            Ch2 = Ch2+Double(L2)*(t-tp)
//            print("Chas \(t)")
//            print("Kilkist pruunuatux zauavok  \(n)")
//            print("Kilkist obroblenux zauavok \(Nobr)")
//            print("Kilkist vidmovlenux zauavok  \(Notk)")
//            print("Chas robotu kanaly 11 \(r11)")
//            print("Chas robotu kanaly 12 \(r12)")
//            print("Chas robotu kanaly 2 \(r2)")
//            print("Kilkist zauavok v 1 cherzi \(L1)")
//            print("Kilkist zauavok v 2 cherzi \(L2)")
            
            if sob == 1 {
                Vxod_v_SMO1()
                
            }
            if sob == 2  {
                Vuxod_iz_SMO1()
                
            }
            if sob == 3 {
                Vuxid_iz_SMO2()
                
            }
            
        }
        var str = ""
        
        str += "Кількість оброблених заявок \(Nobr)\n"
        str += "Кількість відмовлених заявок  \(Notk)\n"
        str += "Ймовірність відмови \(Double(Notk)/Double(Notk+Nobr))\n"
        str += "Середня довжина 1 черги \(Ch1/Tmod)\n"
        str += "Середня довжина 2 черги \(Ch2/Tmod)\n"
        str += "Середній час очікування в 1 черзі \(Ch1/Double(n))\n"
        str += "Середній час очікування в 2 черзі \(Ch2/Double(n))\n"
        
        label.stringValue = str
        
        print("End")
    }
    
    
}

import Foundation

class Generator {
    func random(lambda: Double) -> Double {
        let sig = Double.random(in: 0...1)
        return (-1.0/lambda) * log(sig)
    }
    
    func calcRegression(lambda: Double, x: Double) -> Double {
        return (1.0 - exp((-1.0 * lambda * x)))
    }
}

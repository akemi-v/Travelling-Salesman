//
//  MatrixCell.swift
//  Travelling Salesman
//
//  Created by Maria Semakova on 11/8/17.
//  Copyright © 2017 Maria Semakova. All rights reserved.
//

import Foundation

class MatrixCell : NSObject, NSCoding {
    
    let row : Int
    let col : Int
    var cost : Int = 0
    
    let maxCost : UInt32 = 100
    
    init(row: Int, col: Int) {
        self.row = row
        self.col = col
        
        if col != row {
            self.cost = randomCost(maxCost: maxCost)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let row = aDecoder.decodeObject(forKey: "row") as? Int32,
            let col = aDecoder.decodeObject(forKey: "col") as? Int32,
            let cost = aDecoder.decodeObject(forKey: "cost") as? Int32 else {
                return nil
        }
        
        self.row = Int(row)
        self.col = Int(col)
        self.cost = Int(cost)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.row, forKey: "row")
        aCoder.encode(self.col, forKey: "col")
        aCoder.encode(self.cost, forKey: "cost")
    }

    
//    private func randomCost() -> Int {
//        return Int(arc4random_uniform(maxCost) + 1)
//    }
    
    func symmetric() -> MatrixCell {
        let symmetricCell = MatrixCell(row: col, col: row)
        symmetricCell.cost = self.cost
        return symmetricCell
    }
}

func randomCost(maxCost: UInt32) -> Int {
    return Int(arc4random_uniform(maxCost) + 1)
}


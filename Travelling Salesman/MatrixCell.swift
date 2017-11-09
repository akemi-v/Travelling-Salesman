//
//  MatrixCell.swift
//  Travelling Salesman
//
//  Created by Maria Semakova on 11/8/17.
//  Copyright © 2017 Maria Semakova. All rights reserved.
//

import Foundation

class MatrixCell {
    let row : Int
    let col : Int
    var cost : Int = 0
    
    let maxCost : UInt32 = 100
    
    init(row: Int, col: Int) {
        self.row = row
        self.col = col
        
        if col != row {
            self.cost = randomCost()
        }
    }
    
    private func randomCost() -> Int {
        return Int(arc4random_uniform(maxCost) + 1)
    }
    
    func symmetric() -> MatrixCell {
        let symmetricCell = MatrixCell(row: self.col, col: self.row)
        symmetricCell.cost = self.cost
        return symmetricCell
    }
}

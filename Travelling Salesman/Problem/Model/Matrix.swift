//
//  Matrix.swift
//  Travelling Salesman
//
//  Created by Maria Semakova on 11/8/17.
//  Copyright © 2017 Maria Semakova. All rights reserved.
//

import Foundation

class Matrix {
    let rows : Int
    let cols : Int
    var cells : [[MatrixCell]] = []
    
    init(rows: Int, cols: Int) {
        self.rows = rows
        self.cols = cols
        
        for row in 0..<rows {
            var cellsRow : [MatrixCell] = []
            
            for col in 0..<cols {
                if col >= row {
                    let cell = MatrixCell(row: row, col: col)
                    cellsRow.append(cell)
                } else {
                    let cell = self.cells[col][row].symmetric()
                    cellsRow.append(cell)
                }
            }
            
            self.cells.append(cellsRow)
        }
    }
}

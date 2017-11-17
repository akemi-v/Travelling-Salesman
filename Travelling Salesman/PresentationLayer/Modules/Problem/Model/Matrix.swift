//
//  Matrix.swift
//  Travelling Salesman
//
//  Created by Maria Semakova on 11/8/17.
//  Copyright © 2017 Maria Semakova. All rights reserved.
//

import Foundation

class Matrix : NSObject, NSCoding {
    
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
    
    init(rows: Int, cols: Int, costs: [[Int]]) {
        self.rows = rows
        self.cols = cols
        
        for row in 0..<rows {
            var cellsRow : [MatrixCell] = []
            
            for col in 0..<cols {
                if col >= row {
                    let cell = MatrixCell(row: row, col: col)
                    cell.cost = costs[row][col]
                    cellsRow.append(cell)
                } else {
                    let cell = self.cells[col][row].symmetric()
                    cell.cost = costs[row][col]
                    cellsRow.append(cell)
                }
            }
            
            self.cells.append(cellsRow)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let rows = aDecoder.decodeObject(forKey: "rows") as? Int,
            let cols = aDecoder.decodeObject(forKey: "cols") as? Int,
            let costs = aDecoder.decodeObject(forKey: "costs") as? [[Int]] else {
                return nil
        }
        
        self.rows = Int(rows)
        self.cols = Int(cols)
        
        for row in 0..<rows {
            var cellsRow : [MatrixCell] = []
            
            for col in 0..<cols {
                if col >= row {
                    let cell = MatrixCell(row: row, col: col)
                    cell.cost = costs[row][col]
                    cellsRow.append(cell)
                } else {
                    let cell = self.cells[col][row].symmetric()
                    cell.cost = costs[row][col]
                    cellsRow.append(cell)
                }
            }
            
            self.cells.append(cellsRow)
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.rows, forKey: "rows")
        aCoder.encode(self.cols, forKey: "cols")
        aCoder.encode(self.cells, forKey: "cells")
    }
    
    
}

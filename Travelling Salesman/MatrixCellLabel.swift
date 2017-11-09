//
//  MatrixCellLabel.swift
//  Travelling Salesman
//
//  Created by Maria Semakova on 11/8/17.
//  Copyright © 2017 Maria Semakova. All rights reserved.
//

import UIKit

class MatrixCellLabel: UILabel {
    var cell : MatrixCell
    let cellSize : CGFloat
    
    init(cell:MatrixCell, cellSize:CGFloat) {
        self.cell = cell
        self.cellSize = cellSize
        
        let cellMargin : CGFloat = 0.0
        let x = CGFloat(self.cell.col) * (cellSize + cellMargin)
        let y = CGFloat(self.cell.row) * (cellSize + cellMargin)
        let cellFrame = CGRect(x: x, y: y, width: cellSize, height: cellSize)
        
        super.init(frame: cellFrame)
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}

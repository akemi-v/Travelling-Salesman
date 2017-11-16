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
    let cellSize : CGSize
    
    init(cell:MatrixCell, cellSize:CGSize) {
        self.cell = cell
        self.cellSize = cellSize
        
        let x = CGFloat(self.cell.col) * cellSize.width
        let y = CGFloat(self.cell.row) * cellSize.height
        let cellFrame = CGRect(x: x + cellSize.width, y: y + cellSize.height, width: cellSize.width, height: cellSize.height)
        
        super.init(frame: cellFrame)
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(row: Int, col: Int) {
        self.text = String(cell.cost)
        self.textAlignment = .center
        self.textColor = col > row ? UIColor .black : UIColor .lightGray
        self.layer.borderWidth = col > row ? 1.0 : 0.0
    }

    
}

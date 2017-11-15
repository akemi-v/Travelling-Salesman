//
//  UILabel+Configure.swift
//  Travelling Salesman
//
//  Created by Maria Semakova on 11/15/17.
//  Copyright © 2017 Maria Semakova. All rights reserved.
//

import UIKit

import UIKit

class SideLabel: UILabel {
    
    init(text: String, row: Int, col: Int, labelSize: CGSize) {
        
        let x = CGFloat(col) * labelSize.width
        let y = CGFloat(row) * labelSize.height
        let cellFrame = CGRect(x: x, y: y, width: labelSize.width, height: labelSize.height)

        super.init(frame: cellFrame)
        
        self.text = text
        self.textAlignment = .center
        self.textColor = UIColor .black
        self.layer.borderWidth = 1.0
        self.backgroundColor = UIColor(displayP3Red: 255/255, green: 221/255, blue: 206/255, alpha: 1.0)
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

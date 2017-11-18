
//
//  Solution.swift
//  Travelling Salesman
//
//  Created by Maria Semakova on 11/16/17.
//  Copyright © 2017 Maria Semakova. All rights reserved.
//

import Foundation

class SolutionModel {
    
    let matrix : Matrix
    let cheapestPath : String
    let cost : Int32
    let date : Date
    
    init(matrix: Matrix, cheapestPath: String, cost: Int, date: Date) {
        self.matrix = matrix
        self.cheapestPath = cheapestPath
        self.cost = Int32(cost)
        self.date = date
    }
}

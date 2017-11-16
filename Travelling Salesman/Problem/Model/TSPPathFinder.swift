//
//  CheapestPathFinder.swift
//  Travelling Salesman
//
//  Created by Maria Semakova on 11/16/17.
//  Copyright © 2017 Maria Semakova. All rights reserved.
//

import Foundation

class TSPPathFinder {
    
    let cities : [Any]
//    let costs: [[Int]]
    let matrix : Matrix?
    
//    init(cities: [Any], costs: [[Int]]) {
//        self.cities = cities
//        self.costs = costs
//    }
    
    init(matrix: Matrix) {
        self.matrix = matrix
        self.cities = Array(0..<matrix.cols)
    }
    
    func solveTSP() -> ([Any], Int)? {

        let allPermutations = getAllPermutations(arr: cities)
        let allCompletePaths = getAllCompletePaths(permutations: allPermutations)
        var cheapestPath: [Any] = []
        var minCost: Int = Int.max
        for path in allCompletePaths {
            if path.count < 2 { continue }
            var cost = 0
//            var last = path.first // we know there is one becuase of above line
            guard var last = path.first as? Int else { return nil }
            for next in path[1..<path.count] { // add up all pair distances
                guard let next = next as? Int,
                let segmentCost = matrix?.cells[last][next].cost else { return nil }
                cost += segmentCost
//                cost += costs[last][next]
                last = next
            }
            if cost < minCost {
                minCost = cost
                cheapestPath = path
            }
        }
        return (solution: cheapestPath, cost: minCost)
    }
    
    private func getAllPermutations<T>(arr: [T]) -> [[T]] {
        var permutations: [[T]] = []
        permute(arr: arr, left: 0, right: cities.count - 1, result: &permutations)
        return permutations
    }
    
    private func permute<T>(arr: [T], left: Int, right: Int, result: inout [[T]]) {
        var tempArr = arr
        if (left == right) {
            result.append(tempArr)
        } else {
            for i in left..<right + 1 {
                tempArr.swapAt(left, i)
                permute(arr: tempArr, left: left + 1, right: right, result: &result)
                tempArr.swapAt(left, i)
            }
        }
    }
    
    private func getAllCompletePaths<T>(permutations: [[T]]) -> [[T]] {
        return permutations.map {
            if let first = $0.first {
                return ($0 + [first]) // Path's final point is the start
            } else {
                return []
            }
        }
    }
}

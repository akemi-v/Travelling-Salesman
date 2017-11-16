//
//  ProblemService.swift
//  Travelling Salesman
//
//  Created by Maria Semakova on 11/16/17.
//  Copyright © 2017 Maria Semakova. All rights reserved.
//

import Foundation

protocol ISolutionService {
    func saveSolution(solution: SolutionModel, completionHandler: @escaping (String?) -> Void)
    func loadSolutions(completionHandler: @escaping ([SolutionModel]?, String?) -> Void)
}

class SolutionService : ISolutionService {
    
    let storageManager : IStorageManager
    
    init(storageManager: IStorageManager) {
        self.storageManager = storageManager
    }
    
    func saveSolution(solution: SolutionModel, completionHandler: @escaping (String?) -> Void) {
        storageManager.saveSolution(solution: solution, completionHandler: completionHandler)
    }
    
    func loadSolutions(completionHandler: @escaping ([SolutionModel]?, String?) -> Void) {
        storageManager.loadSolutions(completionHandler: completionHandler)
    }
}

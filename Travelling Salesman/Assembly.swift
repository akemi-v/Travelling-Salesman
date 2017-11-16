//
//  Assembly.swift
//  Travelling Salesman
//
//  Created by Maria Semakova on 11/16/17.
//  Copyright © 2017 Maria Semakova. All rights reserved.
//

import Foundation
import UIKit

class Assembly {
    
    let storageManager : IStorageManager
    
    init() {
        let stack = CoreDataStack()
        self.storageManager = StorageManager(stack: stack)
    }
    
    func problemViewController() -> ProblemViewController {
                
        let storyboard = UIStoryboard(name: "Problem", bundle: nil)
        if let problemVC = storyboard.instantiateInitialViewController() as? ProblemViewController {
            problemVC.title = "Задача"
            problemVC.setDependencies(solutionService: solutionService())
            return problemVC
        }
        return ProblemViewController(nibName: nil, bundle: nil)

    }
    
    func historyViewController() -> HistoryViewController {
        let storyboard = UIStoryboard(name: "History", bundle: nil)
        if let historyVC = storyboard.instantiateInitialViewController() as? HistoryViewController {
            historyVC.title = "История"
            historyVC.setDependencies(solutionService: solutionService())
            return historyVC
        }
        return HistoryViewController(nibName: nil, bundle: nil)
    }
    
    // MARK: - Private methods
    
    private func solutionService() -> ISolutionService {
        return SolutionService(storageManager: storageManager)
    }
}

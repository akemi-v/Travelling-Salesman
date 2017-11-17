//
//  StorageManager.swift
//  Travelling Salesman
//
//  Created by Maria Semakova on 11/16/17.
//  Copyright © 2017 Maria Semakova. All rights reserved.
//

import UIKit
import CoreData

protocol IStorageManager {
    
    func saveSolution(solution: SolutionModel, completionHandler: @escaping (String?) -> Void)
    func loadSolutions(completionHandler: @escaping ([SolutionModel]?, String?) -> Void)
}

class StorageManager: NSObject, IStorageManager {
    
    var stack: ICoreDataStack
    
    init(stack: ICoreDataStack) {
        self.stack = stack
    }
    
    func saveSolution(solution: SolutionModel, completionHandler: @escaping (String?) -> Void) {
        guard let context = stack.saveContext else {
            completionHandler("Save context is not available")
            return
        }
        
        context.perform {
            let tspSolution = TSPEntity.insertTSPEntity(in: context)
            let matrixEntity = MatrixEntity.insertMatrixEntity(in: context)
            matrixEntity?.rows = Int32(solution.matrix.rows)
            matrixEntity?.cols = Int32(solution.matrix.cols)
            
            var costs: [[Int]] = []
            for cellRow in solution.matrix.cells {
                let costRow = cellRow.map({ (cell: MatrixCell) -> Int in
                    return cell.cost
                })
                costs.append(costRow)
            }
            
            matrixEntity?.costs = costs as NSArray
            
            tspSolution?.cheapestPath = solution.cheapestPath
            tspSolution?.date = solution.date
            tspSolution?.cost = solution.cost
            tspSolution?.matrix = matrixEntity
            
            self.stack.performSave(context: context, completionHandler: completionHandler)
        }
        
    }
    
    func loadSolutions(completionHandler: @escaping ([SolutionModel]?, String?) -> Void) {
        
        var solutions: [SolutionModel] = []
        
        guard let context = stack.mainContext else {
            print("Main context is not available")
            completionHandler(nil, "Cannot load solutions")
            return
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TSPEntity")
        
        do {
            let results = try context.fetch(fetchRequest)
            guard let tspResults = results as? [TSPEntity] else {
                completionHandler(nil, "Cannot load solutions")
                return
            }
            
            
            for result in tspResults {
                guard let matrixEntity = result.matrix,
                        let cheapestPath = result.cheapestPath,
                        let date = result.date,
                        let costs = matrixEntity.costs as? [[Int]] else {
                            print("Cannot handle result")
                            return
                }
                
                let matrix = Matrix(rows: Int(matrixEntity.rows), cols: Int(matrixEntity.cols), costs: costs)
                let solution = SolutionModel(matrix: matrix, cheapestPath: cheapestPath, cost: Int(result.cost), date: date)
                solutions.append(solution)
            }
            
            completionHandler(solutions, nil)
        } catch {
            print("Error fetching: \(error)")
            completionHandler(nil, error.localizedDescription)
        }

    }
    
    
    
//    func saveDictData(dictData: [String : String], toUrl: URL?, completionHandler: @escaping (Bool) -> ()) {
//        guard let context = stack.saveContext else { return }
//
//        guard let appUser = AppUser.findOrInsertAppUser(in: context) else { return }
//        appUser.currentUser?.name = dictData["name"]
//        appUser.currentUser?.about = dictData["about"]
//        appUser.currentUser?.pic = dictData["pic"]
//
//        stack.performSave(context: context, completionHandler: completionHandler)
//    }
//
//    func loadDictData(setLoadedDictData: @escaping ([String : String]) -> (), fromUrl: URL?) {
//        guard let context = stack.mainContext else { return }
//
//        var dictData : [String: String] = [:]
//
//        guard let appUser = AppUser.findOrInsertAppUser(in: context) else { return }
//        dictData["name"] = appUser.currentUser?.name
//        dictData["about"] = appUser.currentUser?.about
//        dictData["pic"] = appUser.currentUser?.pic
//
//        DispatchQueue.main.async {
//            setLoadedDictData(dictData)
//        }
//    }
//
}


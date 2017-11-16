//
//  TSPEntity.swift
//  Travelling Salesman
//
//  Created by Maria Semakova on 11/16/17.
//  Copyright © 2017 Maria Semakova. All rights reserved.
//

import Foundation
import CoreData

extension TSPEntity {
//    static func fetchRequestAllTSPEntities(model: NSManagedObjectModel) -> NSFetchRequest<TSPEntity> {
//
//    }
//    
    static func insertTSPEntity(in context: NSManagedObjectContext) -> TSPEntity? {
        
        if let solution = NSEntityDescription.insertNewObject(forEntityName: "TSPEntity", into: context) as? TSPEntity {
            solution.id = generateId()
            
            return solution
        }
        
        return nil
    }
    
    private static func generateId() -> String {
        let string = "\(arc4random_uniform(UINT32_MAX))+\(Date.timeIntervalSinceReferenceDate)+\(arc4random_uniform(UINT32_MAX))".data(using: .utf8)?.base64EncodedString()
        return string!
    }
}

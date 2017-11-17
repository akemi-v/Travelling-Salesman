//
//  MatrixEntity.swift
//  Travelling Salesman
//
//  Created by Maria Semakova on 11/17/17.
//  Copyright © 2017 Maria Semakova. All rights reserved.
//

import Foundation
import CoreData

extension MatrixEntity {
    
    static func insertMatrixEntity(in context: NSManagedObjectContext) -> MatrixEntity? {
        
        if let matrix = NSEntityDescription.insertNewObject(forEntityName: "MatrixEntity", into: context) as? MatrixEntity {
            matrix.id = generateId()
            
            return matrix
        }
        
        return nil
    }
    
    private static func generateId() -> String {
        let string = "\(arc4random_uniform(UINT32_MAX))+\(Date.timeIntervalSinceReferenceDate)+\(arc4random_uniform(UINT32_MAX))".data(using: .utf8)?.base64EncodedString()
        return string!
    }

}

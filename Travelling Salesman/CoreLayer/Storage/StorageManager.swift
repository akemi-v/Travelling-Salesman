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
        
        let tspSolution = TSPEntity.insertTSPEntity(in: context)
        tspSolution?.matrix = solution.matrix
        tspSolution?.cheapestPath = solution.cheapestPath
        tspSolution?.date = solution.date
        tspSolution?.cost = solution.cost
        
        stack.performSave(context: context, completionHandler: completionHandler)
    }
    
    func loadSolutions(completionHandler: @escaping ([SolutionModel]?, String?) -> Void) {
        
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
//    func setOnlineConversation(userID: String, userName: String?) {
//        guard let context = stack.saveContext else { return }
//
//        guard let user = User.findOrInsertUser(userId: userID, name: userName ?? "No name", in: context) else { return }
//        user.name = userName
//        user.isOnline = true
//
//        guard let conversation = Conversation.findOrInsertConversation(userId: userID, name: userName ?? "No name", in: context) else { return }
//        conversation.participant = user
//        conversation.name = userName
//        conversation.isOnline = user.isOnline
//        conversation.date = conversation.lastMessage?.date
//        if conversation.date == nil {
//            conversation.date = Date(timeIntervalSince1970: 0)
//        }
//
//        user.conversations = conversation
//
//        stack.performSave(context: context, completionHandler: nil)
//    }
    
}


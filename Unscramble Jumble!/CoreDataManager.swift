//
//  CoreDataManager.swift
//  Unscramble Jumble!
//
//  Created by Alexander Hall on 6/30/20.
//  Copyright © 2020 Hall Inc. All rights reserved.
//

import CoreData
import UIKit

class CoreDataManager {
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    lazy var context = appDelegate?.persistentContainer.viewContext
    
    public func addAndSaveTotalStatsData(totalGamesPlayed: Int, totalScore: Int, totalWordsSolved: Int) {
        let entity = NSEntityDescription.entity(forEntityName: "TotalStats", in: context!)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        newUser.setValue(totalGamesPlayed, forKey: "totalGamesPlayed")
        newUser.setValue(totalScore, forKey: "totalScore")
        newUser.setValue(totalWordsSolved, forKey: "totalWordsSolved")
        
        do {
            try context!.save()
        } catch {
            fatalError("Could not save data!")
        }
    }
    
    public func addAndSaveBestGameData(bestCategory: String, bestHintsUsed: Int, bestScore: Int, bestWordsSolved: Int) {
        let entity = NSEntityDescription.entity(forEntityName: "BestGame", in: context!)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        newUser.setValue(bestCategory, forKey: "bestCategory")
        newUser.setValue(bestHintsUsed, forKey: "bestHintsUsed")
        newUser.setValue(bestScore, forKey: "bestScore")
        newUser.setValue(bestWordsSolved, forKey: "bestWordsSolved")
        
        do {
            try context!.save()
        } catch {
            fatalError("Could not save data!")
        }
    }
    
    public func fetchTotalStatsData() -> (totalGamesPlayed: Int, totalScore: Int, totalWordsSolved: Int) {
        
        var totalGamesPlayed: UInt32 = 0
        var totalScore: UInt32 = 0
        var totalWordsSolved: UInt32 = 0
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TotalStats")
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context!.fetch(request)
            for data in result as! [NSManagedObject] {
                totalGamesPlayed = (data.value(forKey: "totalGamesPlayed") as! UInt32)
                totalScore = (data.value(forKey: "totalScore") as! UInt32)
                totalWordsSolved = (data.value(forKey: "totalWordsSolved") as! UInt32)
            }
        } catch {
            fatalError("Could not fetch data!")
        }
        return (totalGamesPlayed: Int(totalGamesPlayed), totalScore: Int(totalScore), totalWordsSolved: Int(totalWordsSolved))
    }
    
    public func fetchBestGameData() -> (bestCategory: String, bestHintsUsed: Int, bestScore: Int, bestWordsSolved: Int) {
        
        var bestCategory = "------"
        var bestHintsUsed: UInt32 = 0
        var bestScore: UInt32 = 0
        var bestWordsSolved: UInt32 = 0
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BestGame")
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context!.fetch(request)
            for data in result as! [NSManagedObject] {
                bestCategory = (data.value(forKey: "bestCategory") as! String)
                bestHintsUsed = (data.value(forKey: "bestHintsUsed") as! UInt32)
                bestScore = (data.value(forKey: "bestScore") as! UInt32)
                bestWordsSolved = (data.value(forKey: "bestWordsSolved") as! UInt32)
            }
        } catch {
            fatalError("Could not fetch data!")
        }
        return (bestCategory: bestCategory, bestHintsUsed: Int(bestHintsUsed), bestScore: Int(bestScore), bestWordsSolved: Int(bestWordsSolved))
    }
}

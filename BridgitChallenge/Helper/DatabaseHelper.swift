//
//  DatabaseController.swift
//  BridgitChallenge
//
//  Created by Nan Chen on 2017-11-14.
//  Copyright © 2017 Nan Chen. All rights reserved.
//

import Foundation
import CoreData


class DatabaseHelper {
    // MARK: - Core Data stack
    
    let persistentContainer: NSPersistentContainer

    init(){
        persistentContainer = NSPersistentContainer(name: "BridgitChallenge")
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }

    private static var _INSTANCE: DatabaseHelper?

    static var INSTANCE: DatabaseHelper {
        if let _INSTANCE = _INSTANCE {
            return _INSTANCE
        }
        _INSTANCE = DatabaseHelper()
        return _INSTANCE!
    }
  

    func getViewContext() -> NSManagedObjectContext{
        return persistentContainer.viewContext
    }

    func getBackGroundContext() -> NSManagedObjectContext { 
        return persistentContainer.newBackgroundContext()
    }

    // MARK: - Core Data Saving support
    func saveContext(context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

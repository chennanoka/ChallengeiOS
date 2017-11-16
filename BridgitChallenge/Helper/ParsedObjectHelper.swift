//
// Created by Nan Chen on 2017-11-14.
// Copyright (c) 2017 Nan Chen. All rights reserved.
//

import Foundation
import CoreData

class ParsedObjectHelper {

    func starItem(context: NSManagedObjectContext, parsedObject: ParsedObject) {
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ParsedObject.className)
            fetchRequest.predicate = NSPredicate(format: "id = %@", parsedObject.id!)

            if let fetchResults = try context.fetch(fetchRequest) as? [NSManagedObject] {
                if fetchResults.count == 0 {
                    let databaseObj: ParsedObject = NSEntityDescription.insertNewObject(forEntityName: ParsedObject.className, into: context) as! ParsedObject
                    databaseObj.id = parsedObject.id!
                    databaseObj.title = parsedObject.title ?? ""
                    databaseObj.dateUpdated = parsedObject.dateUpdated ?? ""
                    databaseObj.categoryLabel = parsedObject.categoryLabel ?? ""
                    databaseObj.imgUrl = parsedObject.imgUrl ?? ""
                    databaseObj.contentStr = parsedObject.contentStr ?? ""
                    databaseObj.savedTime = parsedObject.savedTime ?? ""

                } else {
                    let managedObject = fetchResults[0]
                    managedObject.setValue(parsedObject.title, forKey: "title")
                    managedObject.setValue(parsedObject.dateUpdated, forKey: "dateUpdated")
                    managedObject.setValue(parsedObject.categoryLabel, forKey: "categoryLabel")
                    managedObject.setValue(parsedObject.imgUrl, forKey: "imgUrl")
                    managedObject.setValue(parsedObject.contentStr, forKey: "contentStr")
                    managedObject.setValue(parsedObject.savedTime, forKey: "savedTime")
                }

                DatabaseHelper.INSTANCE.saveContext(context: context)
            }

        } catch {
            print("Error:\(error)")
        }

    }

    func saveItem(context: NSManagedObjectContext, parsedValue: [String: String]) {
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ParsedObject.className)
            fetchRequest.predicate = NSPredicate(format: "id = %@", parsedValue["id"]!)

            if let fetchResults = try context.fetch(fetchRequest) as? [NSManagedObject] {
                if fetchResults.count == 0 {
                    let databaseObj: ParsedObject = NSEntityDescription.insertNewObject(forEntityName: ParsedObject.className, into: context) as! ParsedObject
                    databaseObj.id = parsedValue["id"]
                    databaseObj.title = parsedValue["title"] ?? ""
                    databaseObj.dateUpdated = parsedValue["dateUpdated"] ?? ""
                    databaseObj.categoryLabel = parsedValue["categoryLabel"] ?? ""
                    databaseObj.imgUrl = parsedValue["imgUrl"] ?? ""
                    databaseObj.contentStr = parsedValue["contentStr"] ?? ""
                    databaseObj.savedTime = parsedValue["savedTime"]
                } else {
                    let managedObject = fetchResults[0]
                    managedObject.setValue(parsedValue["title"], forKey: "title")
                    managedObject.setValue(parsedValue["dateUpdated"], forKey: "dateUpdated")
                    managedObject.setValue(parsedValue["categoryLabel"], forKey: "categoryLabel")
                    managedObject.setValue(parsedValue["imgUrl"], forKey: "imgUrl")
                    managedObject.setValue(parsedValue["contentStr"], forKey: "contentStr")
                }

                DatabaseHelper.INSTANCE.saveContext(context: context)
            }

        } catch {
            print("Error:\(error)")
        }
    }

    func unStarItem(context: NSManagedObjectContext, id: String) {
        do {

            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ParsedObject.className)
            fetchRequest.predicate = NSPredicate(format: "id = %@", id)

            if let fetchResults = try context.fetch(fetchRequest) as? [NSManagedObject] {
                if fetchResults.count != 0 {
                    let managedObject = fetchResults[0]
                    managedObject.setValue(nil, forKey: "savedTime")
                }

                DatabaseHelper.INSTANCE.saveContext(context: context)
            }

        } catch {
            print("Error:\(error)")
        }
    }

    func fetchStarredItem(context: NSManagedObjectContext) -> [ParsedObject]? {
        do {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: ParsedObject.className)
            request.predicate = NSPredicate(format: "savedTime != nil")
            let sort = NSSortDescriptor(key: #keyPath(ParsedObject.dateUpdated), ascending: false)
            request.sortDescriptors = [sort]

            if let items = try context.fetch(request) as? [ParsedObject] {
                return items
            }
            return nil
        } catch {
            return nil
        }
    }

    func fetchParsedItem(context: NSManagedObjectContext) -> [ParsedObject]? {
        do {
            let request1 = NSFetchRequest<NSFetchRequestResult>(entityName: ParsedObject.className)
            request1.predicate = NSPredicate(format: "savedTime = nil")
            
            let request2 = NSFetchRequest<NSFetchRequestResult>(entityName: ParsedObject.className)
            request2.predicate = NSPredicate(format: "savedTime != nil")
            
            if let items1 = try context.fetch(request1) as? [ParsedObject], var items2 = try context.fetch(request2) as? [ParsedObject]  {
                items2.append(contentsOf: items1)
                return items2
            }
//            let sort = NSSortDescriptor(key: #keyPath(ParsedObject.dateUpdated), ascending: false)
//            request.resultType = .dictionaryResultType
//            request.propertiesToGroupBy = ["savedTime", "dateUpdated", "title", "id", "categoryLabel", "imgUrl", "contentStr"]
//            request.propertiesToFetch = ["id", "title", "dateUpdated", "categoryLabel", "imgUrl", "contentStr", "savedTime"]
//            request.sortDescriptors = [sort]

//            if let items = try context.fetch(request) as? [NSDictionary] {
//                var objectsArray = [ParsedObject]()
//                for item in items {
//                    let request1 = NSFetchRequest<NSFetchRequestResult>(entityName: ParsedObject.className)
//                        request1.predicate = NSPredicate(format: "id = %@", item["id"] as! String)
//                        if let fetchResults = try context.fetch(request1) as? [ParsedObject] {
//                            if fetchResults.count != 0 {
//                                 objectsArray.append(fetchResults[0])
//                            }
//                        }
//                }
//                return objectsArray
//            }
            return nil
        } catch {
            return nil
        }
    }
}

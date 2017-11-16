///Users/nanchen/Documents/BridgitChallenge/BridgitChallengeTests
//  BridgitChallengeTests.swift
//  BridgitChallengeTests
//
//  Created by Nan Chen on 2017-11-10.
//  Copyright © 2017 Nan Chen. All rights reserved.
//

import XCTest
import CoreData

import Foundation
import Alamofire
import SWXMLHash

@testable import BridgitChallenge

class BridgitChallengeTests: XCTestCase {

    var context: NSManagedObjectContext!
    var helper: ParsedObjectHelper!

    func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!

        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)

        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        } catch {
            print("Adding in-memory persistent store failed")
        }

        let managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator

        return managedObjectContext
    }

    override func setUp() {
        super.setUp()

        context = setUpInMemoryManagedObjectContext()
        helper = ParsedObjectHelper.init()

        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testStar() {

        let parsedObject1 = NSEntityDescription.insertNewObject(forEntityName: ParsedObject.className, into: context) as! ParsedObject
        parsedObject1.id = "1"

        let parsedObject2 = NSEntityDescription.insertNewObject(forEntityName: ParsedObject.className, into: context) as! ParsedObject
        parsedObject2.id = "2"

        helper.starItem(context: context, parsedObject: parsedObject1)

        helper.starItem(context: context, parsedObject: parsedObject2)

        XCTAssertEqual(2, (helper.fetchParsedItem(context: context) == nil ? [] : helper.fetchParsedItem(context: context)!).count)

        helper.unStarItem(context: context, id: "1")

        XCTAssertEqual(1, (helper.fetchParsedItem(context: context) == nil ? [] : helper.fetchParsedItem(context: context)!).count)

    }

    //    func testGetFromServer() {
    //
    //        XCTAssertTrue(helper.fetchParsedItem(context:context) != nil && helper.fetchParsedItem(context:context)!.count == 0)
    //
    //        let manager = NetWorkManager()
    //        manager.getFromServer(context:context)
    //
    //        XCTAssertTrue(helper.fetchParsedItem(context:context)!.count>0)
    //    }
    //

}

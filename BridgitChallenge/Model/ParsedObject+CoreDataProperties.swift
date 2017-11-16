//
//  ParsedObject+CoreDataProperties.swift
//  BridgitChallenge
//
//  Created by Nan Chen on 2017-11-14.
//  Copyright © 2017 Nan Chen. All rights reserved.
//
//

import Foundation
import CoreData

extension ParsedObject {


    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var dateUpdated: String?
    @NSManaged public var categoryLabel: String?
    @NSManaged public var imgUrl: String?
    @NSManaged public var contentStr: String?
    @NSManaged public var savedTime: String?
}

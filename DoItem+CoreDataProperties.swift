//
//  DoItem+CoreDataProperties.swift
//  ToDoList
//
//  Created by İrem Ergun on 25/07/2017.
//  Copyright © 2017 İrem Ergun. All rights reserved.
//

import Foundation
import CoreData


extension DoItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DoItem> {
        return NSFetchRequest<DoItem>(entityName: "DoItem")
    }

    @NSManaged public var name: String?
    @NSManaged public var detail: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var isDone: Bool

}

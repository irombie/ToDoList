//
//  DoItem+CoreDataClass.swift
//  ToDoList
//
//  Created by İrem Ergun on 25/07/2017.
//  Copyright © 2017 İrem Ergun. All rights reserved.
//

import Foundation
import CoreData

@objc(DoItem)
public class DoItem: NSManagedObject {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
    }

}

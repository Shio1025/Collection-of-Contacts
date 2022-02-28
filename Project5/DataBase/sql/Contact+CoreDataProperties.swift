//
//  Contact+CoreDataProperties.swift
//  Project5
//
//  Created by shio birbichadze on 1/14/22.
//  Copyright © 2022 shio birbichadze. All rights reserved.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var name: String?
    @NSManaged public var number: String?

}

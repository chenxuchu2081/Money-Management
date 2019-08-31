//
//  Category_Income+CoreDataProperties.swift
//  Money Management
//
//  Created by CHEN Xuchu on 29/8/2019.
//  Copyright © 2019 CHEN Xuchu. All rights reserved.
//
//

import Foundation
import CoreData


extension Category_Income {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category_Income> {
        return NSFetchRequest<Category_Income>(entityName: "Category_Income")
    }

    @NSManaged public var image: NSData?
    @NSManaged public var name: String?

}

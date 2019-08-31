//
//  Category_Expend+CoreDataProperties.swift
//  Money Management
//
//  Created by CHEN Xuchu on 29/8/2019.
//  Copyright © 2019 CHEN Xuchu. All rights reserved.
//
//

import Foundation
import CoreData


extension Category_Expend {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category_Expend> {
        return NSFetchRequest<Category_Expend>(entityName: "Category_Expend")
    }

    @NSManaged public var image: NSData?
    @NSManaged public var name: String?

}

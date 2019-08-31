//
//  Expend+CoreDataProperties.swift
//  Money Management
//
//  Created by CHEN Xuchu on 22/8/2019.
//  Copyright © 2019 CHEN Xuchu. All rights reserved.
//
//

import Foundation
import CoreData


extension Expend {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expend> {
        return NSFetchRequest<Expend>(entityName: "Expend")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var desc: String?
    @NSManaged public var expend_ID: String?
    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var image: NSData?

}

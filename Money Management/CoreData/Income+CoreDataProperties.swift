//
//  Income+CoreDataProperties.swift
//  Money Management
//
//  Created by CHEN Xuchu on 22/8/2019.
//  Copyright © 2019 CHEN Xuchu. All rights reserved.
//
//

import Foundation
import CoreData


extension Income {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Income> {
        return NSFetchRequest<Income>(entityName: "Income")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var desc: String?
    @NSManaged public var image: NSData?
    @NSManaged public var income_ID: String?
    @NSManaged public var name: String?
    @NSManaged public var price: Double

}

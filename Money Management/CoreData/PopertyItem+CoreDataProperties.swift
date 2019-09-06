//
//  PopertyItem+CoreDataProperties.swift
//  Money Management
//
//  Created by CHEN Xuchu on 2/9/2019.
//  Copyright © 2019 CHEN Xuchu. All rights reserved.
//
//

import Foundation
import CoreData


extension PopertyItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PopertyItem> {
        return NSFetchRequest<PopertyItem>(entityName: "PopertyItem")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var image: NSData?
    @NSManaged public var desc: String?
    @NSManaged public var price: Double
    @NSManaged public var date: NSDate?
    @NSManaged public var type: String?

}

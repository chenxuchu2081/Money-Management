//
//  Notifications+CoreDataProperties.swift
//  
//
//  Created by CHEN Xuchu on 16/9/2019.
//
//

import Foundation
import CoreData


extension Notifications {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Notifications> {
        return NSFetchRequest<Notifications>(entityName: "Notifications")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var isDelete: Bool
    @NSManaged public var isPend: Bool
    @NSManaged public var time: NSDate?

}

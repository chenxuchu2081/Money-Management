//
//  ConsumeType+CoreDataProperties.swift
//  Money Management
//
//  Created by CHEN Xuchu on 21/8/2019.
//  Copyright © 2019 CHEN Xuchu. All rights reserved.
//
//

import Foundation
import CoreData


extension ConsumeType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ConsumeType> {
        return NSFetchRequest<ConsumeType>(entityName: "ConsumeType")
    }

    @NSManaged public var name: String?
    @NSManaged public var image: NSData?
    @NSManaged public var id: String?

}

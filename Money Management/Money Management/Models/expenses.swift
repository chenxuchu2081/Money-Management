//
//  expenses.swift
//  Money Management
//
//  Created by CHEN Xuchu on 20/8/2019.
//  Copyright © 2019 CHEN Xuchu. All rights reserved.
//

import Foundation

class expenses: NSObject{
    var typeName: String?
    var typeImage: String?
    var price: Double?
    var date: Date?
    
    init(typeName: String, typeImage: String, price: Double, date: Date) {
        self.typeName = typeName
        self.typeImage  = typeImage
        self.price = price
        self.date = date
    }
    
    
    
    
   
//    deinit {
//
//    }
}

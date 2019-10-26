//
//  File.swift
//  Money Management
//
//  Created by CHEN Xuchu on 13/9/2019.
//  Copyright © 2019 CHEN Xuchu. All rights reserved.
//

import Foundation

class PopertyItemObject{
    
    
    public var id : String?
    public var name: String?
    public var desc: String?
    public var price: Double?
    public var date: Date?
    public var image: Data?
    public var type: String?
    
    internal init(id: String?, name: String?, desc: String?, price: Double?, date: Date?, image: Data?, type: String?) {
        self.id = id
        self.name = name
        self.desc = desc
        self.price = price
        self.date = date
        self.image = image
        self.type = type
    }
    
    deinit {
        
    }
}

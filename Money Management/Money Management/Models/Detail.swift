//
//  Detail.swift
//  Money Management
//
//  Created by CHEN Xuchu on 27/8/2019.
//  Copyright © 2019 CHEN Xuchu. All rights reserved.
//

import Foundation

class Detail{
    var id: String?
    var detailName: String?
    var detailImage: Data?
    var detailPrice: Double?
    var detailDate: Date?
    var dateilDesc: String?
    var detailType: String?
    
    init(id: String, name: String, image: Data, price: Double, desc: String, date: Date, type: String) {
        self.id = id
        self.detailName = name
        self.detailImage = image
        self.detailPrice = price
        self.detailDate = date
        self.dateilDesc = desc
        self.detailType = type
    }
}

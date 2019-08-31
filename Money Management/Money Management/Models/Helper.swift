//
//  Helper.swift
//  Money Management
//
//  Created by CHEN Xuchu on 20/8/2019.
//  Copyright © 2019 CHEN Xuchu. All rights reserved.
//

import Foundation

class Helper: NSObject{
    
    
    
    static func FormatDate(dates: Date) -> String{
        let formatString = DateFormatter()
        formatString.dateFormat = "MM-dd-yyyy"
        let whatTime = formatString.string(from: dates)
        
        print(whatTime)
        return whatTime
    }
    
   static func stringConvertDate(string:String, dateFormat:String="MM-dd-yyyy") -> Date {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.date(from: string)
        return date!
    }
    
    
    
    
}

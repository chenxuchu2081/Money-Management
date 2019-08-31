//
//  Expend.swift
//  Money Management
//
//  Created by CHEN Xuchu on 22/8/2019.
//  Copyright © 2019 CHEN Xuchu. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Expends: NSObject {
    
//    var container: NSPdersistentContainer!
    let app = UIApplication.shared.delegate as! AppDelegate
    var viewContext: NSManagedObjectContext!
    
    
    func inserData(bundles_3Item: [String], price: Double, Date:Date ){
        let data = NSEntityDescription.insertNewObject(forEntityName: "Expend", into: viewContext) as! Expend
        
        var name = bundles_3Item[0]
        var image = bundles_3Item[1]
        var desc = bundles_3Item[2]
        
        var getCountOfDB = queryNumberOfExpends()
        
        if getCountOfDB > 0 {
            data.expend_ID = String(getCountOfDB + 1)
        }else{
            return
        }
        
        //data.expend_ID =
        data.name = name
        data.desc = desc
//        data.image = NSData(coder: NSCoder)
        data.price = price
        data.date = Date as NSDate
        
        
        app.saveContext()
        
    }
    
    func queryNumberOfExpends() -> Int{
        var numbers: Int?
        do{
            let allData = try viewContext.fetch(Expend.fetchRequest())
            
            var data = allData as! [Expend]
             numbers = data.count
            
            //for data in allData as! [Expend]{

//            }
        }catch{
            print(error)
        }
        return numbers!
    }
    
}

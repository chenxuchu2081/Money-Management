//
//  CoreData.swift
//  Money Management
//
//  Created by CHEN Xuchu on 21/8/2019.
//  Copyright © 2019 CHEN Xuchu. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDatas: NSObject{
    
    var container: NSPersistentContainer!
    let app = UIApplication.shared.delegate as! AppDelegate
    var viewContext: NSManagedObjectContext!
    
    func initViewContext(){
        
         viewContext = app.persistentContainer.viewContext
    }
    
    //     func inserData<T: Equatable>(Item: [T]){}
    func inserData(){
        var data = NSEntityDescription.insertNewObject(forEntityName: "ConsumeType", into: viewContext) as! ConsumeType
        data.id = "001"
        data.name = "XUCHU"
        
        app.saveContext()
        
    }
    
    func queryData(){
        do{
            let allData = try viewContext.fetch(ConsumeType.fetchRequest())
            for data in allData as! [ConsumeType]{
                print("\(data.id), \(data.name)")
            }
        }catch{
            print(error)
        }
    }
    
    
    
    
    
}

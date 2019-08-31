//
//  HomeDetailVC.swift
//  Money Management
//
//  Created by CHEN Xuchu on 27/8/2019.
//  Copyright © 2019 CHEN Xuchu. All rights reserved.
//

import UIKit
import CoreData
class HomeDetailVC: UIViewController {

//    var detailName: String?
//    var detailImage: Data?
//    var detailPrice: Double?
//    var detailDate: Date?
//    var dateilDesc: String?
    
    var detail: Detail!
    
    var deleteObjectId: String?
    
    @IBOutlet weak var detailName: UILabel!
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var detailPrice: UILabel!
    @IBOutlet weak var detailDate: UILabel!
    @IBOutlet weak var deteilDesc: UILabel!
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var viewContext: NSManagedObjectContext!
    
    let fetchRequest = NSFetchRequest<Expend>(entityName: "Expend")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewContext = app.persistentContainer.viewContext
        
        if detail != nil{
            deleteObjectId = detail.id
            detailName.text = detail.detailName
            if detail.detailImage != nil{
                detailImage.image = UIImage(data: detail.detailImage!)
            }
            detailPrice.text = String(detail.detailPrice!)
            detailDate.text = Helper.FormatDate(dates: detail.detailDate!)
            deteilDesc.text = detail.dateilDesc
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func deleteObject(id: String){
        fetchRequest.predicate = NSPredicate(format: "expend_ID = %@", id)
        do{
            let search = try viewContext.fetch(fetchRequest)
            let delete = search[0] as! NSManagedObject
            viewContext.delete(delete)
            do{
                try viewContext.save()
            }catch{
                print(error)
            }
        }catch{
            print(error.localizedDescription)
        }
    }

    @IBAction func rubbish(){

            deleteObject(id: deleteObjectId!)
        print("remember to remind user deleting message")
        let des = storyboard?.instantiateViewController(withIdentifier: "HomePageCV")
        show(des!, sender: self)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

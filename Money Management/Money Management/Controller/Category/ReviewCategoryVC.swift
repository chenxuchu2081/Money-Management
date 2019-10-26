//
//  ReviewCategoryVC.swift
//  Money Management
//
//  Created by CHEN Xuchu on 30/8/2019.
//  Copyright © 2019 CHEN Xuchu. All rights reserved.
//

import UIKit
import CoreData

private let identifiers = "CategoryCell"
class ReviewCategoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var viewContext: NSManagedObjectContext!

    var Expendcontroller = NSFetchedResultsController<Category_Expend>()
    var IncomeController = NSFetchedResultsController<Category_Income>()
    
    var isExpendSegment = true
    var isIncomeSegment = false
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    //MARK: - ViewControler LifeCircle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewContext = app.persistentContainer.viewContext
        
        if isExpendSegment == true{
            segmentedControl.isEnabledForSegment(at: 0)
        fetchCategory_Expend_Data(entityName: "Category_Expend")
        }else{
            segmentedControl.isEnabledForSegment(at: 1)
            fetchCategory_Income_Data(entityName: "Category_Income")
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isExpendSegment == true{
            refresh(entityName: "Category_Expend")
        }else{
            refresh(entityName: "Category_Income")
        }
    }
     
     //FIXME: - UI Segmented control
    @IBAction func changeExpend_Income(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            isExpendSegment = true
            isIncomeSegment = false
            refresh(entityName: "Category_Expend")
        }else{
            isIncomeSegment = true
            isExpendSegment = false
            refresh(entityName: "Category_Income")
        }
    }
    
    //MARK: - TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        if isExpendSegment == true{
            return Expendcontroller.sections!.count
        }else{
            return IncomeController.sections!.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isExpendSegment == true{
        return self.Expendcontroller.sections![section].numberOfObjects
        }else{
            return self.IncomeController.sections![section].numberOfObjects
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifiers, for: indexPath) as! ReviewCategoryTVC
        
        if isExpendSegment == true{
        //coreData的数据模型的获取
        let list = self.Expendcontroller.object(at: indexPath)
            cell.nameLabel.text = list.name
            if list.image != nil{
                cell.imageview.image = UIImage(data: list.image! as Data)
                cell.imageview.layer.cornerRadius = 25
                cell.imageview.layer.masksToBounds = true
            }
        }else{
        let list = self.IncomeController.object(at: indexPath)
            cell.nameLabel.text = list.name
            if list.image != nil{
                cell.imageview.image = UIImage(data: list.image! as Data)
                cell.imageview.layer.cornerRadius = 25
                cell.imageview.layer.masksToBounds = true
            }
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Delete?"
    }
    
    
    //more option for table
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let moreaction = UITableViewRowAction(style: .normal, title: "More"){
            (action, indexPath) in
        }
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete?") {
            (action, indexPath) in
            
                if self.isExpendSegment == true{
                    do{
                    let ToDelete = self.Expendcontroller.object(at: indexPath)
                    self.viewContext.delete(ToDelete)
                        try self.app.saveContext()
                        self.fetchCategory_Expend_Data(entityName: "Category_Expend")//fetch for update
                    }catch{
                        print(error)
                    }
                }else{
                    do{
                    let ToDelete = self.IncomeController.object(at: indexPath)
                    self.viewContext.delete(ToDelete)
                         try self.app.saveContext()
                        self.fetchCategory_Income_Data(entityName: "Category_Income")
                    }catch{
                        print(error)
                    }
                }
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        return [moreaction, deleteAction]
    }
    
    //MARK: - fetch Data
    func fetchCategory_Expend_Data(entityName: String){
        let fetchRequest = NSFetchRequest<Category_Expend>(entityName: entityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
//        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        Expendcontroller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try Expendcontroller.performFetch()
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
    }
    
    func fetchCategory_Income_Data(entityName: String){
        let fetchRequest = NSFetchRequest<Category_Income>(entityName: entityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        IncomeController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
        do{
            try IncomeController.performFetch()
        }catch{
            fatalError("Failed to fetch entities: \(error)")
        }
    }
    
    func refresh(entityName: String){
        if isExpendSegment == true{
        fetchCategory_Expend_Data(entityName: entityName)
        }else{
            fetchCategory_Income_Data(entityName: entityName)
        }
        tableView.reloadData()
    }
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toAddReviewVC"{
            let vc = segue.destination as? AddCategoryVC
            if isExpendSegment == true{
                vc?.isWhichSegmentName = "Expend"
            }else{
                vc?.isWhichSegmentName = "Income"
            }
        }
    }
    

}

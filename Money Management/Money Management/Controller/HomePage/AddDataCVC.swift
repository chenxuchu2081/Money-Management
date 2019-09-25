//
//  AddDataCVC.swift
//  Money Management
//
//  Created by CHEN Xuchu on 20/8/2019.
//  Copyright © 2019 CHEN Xuchu. All rights reserved.
//

import UIKit
import CoreData
private let reuseIdentifier = "IconCell"

class AddDataCVC: UICollectionViewController, NSFetchedResultsControllerDelegate{
    
    
    //    var container: NSPersistentContainer!
    //
    let app = UIApplication.shared.delegate as! AppDelegate
    var viewContext: NSManagedObjectContext!
    
    var Expendcontroller = NSFetchedResultsController<Category_Expend>()
    var IncomeController = NSFetchedResultsController<Category_Income>()
    var expendName : String? = "支出"
    var incomeName : String? = "收入"
    var isChangeNavTitleExpend: Bool? = true
    var editData: PopertyItemObject!
    
    
    @IBOutlet weak var toolbar: UIToolbar!
    //var lists = [(name:String, image: String)]()
    @IBOutlet weak var navigationTitle: UINavigationItem!
    @IBOutlet weak var collectionsView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        viewContext = app.persistentContainer.viewContext
        
        // The persistent container is available.
        //        guard container != nil else {
        //            fatalError("This view needs a persistent container.")
        //        }
        //        viewContext = container.viewContext
        
        print(NSPersistentContainer.defaultDirectoryURL())
        
        fetchCategory_Expend_Data(entityName: "Category_Expend")
//        lists.append((name: "contract", image: "contract"))
//        lists.append((name: "global", image: "global"))
//        lists.append((name: "hand", image: "hand-shake"))
//        lists.append((name: "user", image: "man-user"))
//        lists.append((name: "books", image: "open-book"))
//        lists.append((name: "phoneCall", image: "phone-call"))
        
        
        for tmp in view.subviews{
            if tmp is UITextField{
                (tmp as! UITextField).inputAccessoryView = toolbar
            }
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        // self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if editData != nil{
            updateDate(id: editData.id!, name: editData.name!, image: editData.image!)
        }
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if isChangeNavTitleExpend == true{
            return Expendcontroller.sections!.count
        }else{
            return IncomeController.sections!.count
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if isChangeNavTitleExpend == true{
            return Expendcontroller.sections![section].numberOfObjects
        }else{
            return IncomeController.sections![section].numberOfObjects
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        
        
        if isChangeNavTitleExpend == true{
            let lists = self.Expendcontroller.object(at: indexPath)
            // Configure the cell
            let image = cell.viewWithTag(100) as? UIImageView
            let name = cell.viewWithTag(200) as? UILabel
            
            if image != nil{
                image!.image = UIImage(data: (lists.image as? Data)!)
            }
            if name != nil{
                name!.text = lists.name
            }
        }else{
            let lists = self.IncomeController.object(at: indexPath)
            // Configure the cell
            let image = cell.viewWithTag(100) as? UIImageView
            let name = cell.viewWithTag(200) as? UILabel
            
            if image != nil{
                image!.image = UIImage(data: (lists.image as? Data)!)
            }
            if name != nil{
                name!.text = lists.name
            }
        }
        
       
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var name: String?
        var image: Data?
        if isChangeNavTitleExpend == true{
            let lists = self.Expendcontroller.object(at: indexPath)
            if lists.name != nil, lists.image != nil{
                name = lists.name
                image = lists.image as Data?
            }
        }else{
            let lists = self.IncomeController.object(at: indexPath)
            if lists.name != nil, lists.image != nil{
                name = lists.name
                image = lists.image as Data?
            }
        }
        
        if editData != nil{
            updateDate(id: editData.id!, name: name!, image: image!)
        }else{
            insertAlert(name: name!, image: image!)
        }
            
    }
    
    func insertAlert(name: String, image: Data){
        var price: Double?
        var desc: String?
        var date: Date?
        let name = name
        let image = image
        
        let alert = UIAlertController(title: "輸入這筆資料？", message: name , preferredStyle: .alert)
        let cancleAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let sureAction = UIAlertAction(title: "確定", style: .default){
            (action) in
            price = Double(alert.textFields![0].text!)
            desc = alert.textFields![1].text ?? "沒有"
            date = Helper.stringConvertDate(string: alert.textFields![2].text!)
            
            
            //insertData to core data in expends
            let data = NSEntityDescription.insertNewObject(forEntityName: "PopertyItem", into: self.viewContext) as! PopertyItem
            if price == nil{
                AlertMessages.showErrorAlert(title: "Save Error", msg: "the price space should be filled in", vc: self)
            }else{
                data.id = UUID().uuidString //generate  Unique Identifier
                data.name = name
                data.image = UIImage(data: image)?.jpegData(compressionQuality: 0.9) as NSData?
                data.desc = desc!
                data.price = price!
                data.date = date! as NSDate
                if self.isChangeNavTitleExpend == true{
                    data.type = "支出"
                }else{
                    data.type = "收入"
                }
                
                self.app.saveContext()
                AlertMessages.showSuccessfulMessage(title: "Successful", msg: "Data save successfully", vc: self)
            }
            
            

            
        }
        
        alert.addTextField{
            (textField) in
            textField.placeholder = "價錢"
            textField.keyboardType = .numberPad
            textField.layer.cornerRadius = 8
            //            textField.text = name
            
        }
        alert.addTextField{
            (textField) in
            textField.placeholder = "備忘(可選)"
            
        }
        alert.addTextField{
            (textField) in
            textField.placeholder = "日期"
            textField.text = Helper.FormatDate(dates: Date())
            
        }
        alert.addAction(sureAction)
        alert.addAction(cancleAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func updateDate(id: String, name: String, image: Data){
        var price: Double?
        var desc: String?
        var date: Date?
        let name = name
        let image = image
        
        let alert = UIAlertController(title: "修改這筆資料？", message: name , preferredStyle: .alert)
        let cancleAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let sureAction = UIAlertAction(title: "確定", style: .default){
            (action) in
            price = Double(alert.textFields![0].text!)
            desc = alert.textFields![1].text ?? "沒有"
            date = Helper.stringConvertDate(string: alert.textFields![2].text!)
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PopertyItem")
        request.predicate = nil
        let updateID = id
        request.predicate =
            NSPredicate(format: "id = %@", updateID)
        do {
            let results =
                try self.viewContext.fetch(request) as! [PopertyItem]
            
                if price == nil{
                    AlertMessages.showErrorAlert(title: "Update Error", msg: "the price space should be filled in", vc: self)
                }else{
                    results[0].setValue(name, forKey: "name")
                    results[0].setValue(desc, forKey: "desc")
                    results[0].setValue(price, forKey: "price")
                    //results[0].type = ""
                    results[0].setValue(date as NSDate?, forKey: "date")
                    results[0].setValue(UIImage(data: image)?.jpegData(compressionQuality: 0.9) as NSData?, forKey: "image")
                    if self.isChangeNavTitleExpend == true{
                        results[0].setValue("支出", forKey: "type")
                    }else{
                        results[0].setValue("收入", forKey: "type")
                    }
                    
                    try self.app.saveContext()
                    AlertMessages.showSuccessfulMessage(title: "Successful", msg: "Data Update successfully", vc: self)
                }
            
        } catch {
            fatalError("\(error)")
        }
        }
        alert.addTextField{
            (textField) in
            textField.placeholder = "價錢"
            textField.keyboardType = .numberPad
            textField.layer.cornerRadius = 8
            if self.editData != nil{
                textField.text = String(self.editData.price!)
            }
            
        }
        alert.addTextField{
            (textField) in
            textField.placeholder = "備忘(可選)"
            if self.editData != nil{
                textField.text = self.editData.desc
            }
            
        }
        alert.addTextField{
            (textField) in
            textField.placeholder = "日期"
            if self.editData != nil{
                textField.text = Helper.FormatDate(dates: self.editData.date!)
            }
            
            
        }
        alert.addAction(sureAction)
        alert.addAction(cancleAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func queryData(){
        do{
            let printData = try viewContext.fetch(PopertyItem.fetchRequest())
            for datas in printData as! [PopertyItem]{
                print("\(String(describing: datas.name)), \(String(describing: datas.desc))")
            }
        }catch{
            print(error)
        }
    }
    
    
    
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
    @IBAction func closeKeyboardBtn(_ sneder: Any){
        UIView.animate(withDuration: 0.3){
            self.view.endEditing(true)
        }
    }
    
    @IBAction func selectExpendOrIncome(_ sender: UIBarButtonItem){
        if isChangeNavTitleExpend == true{
            navigationTitle.title = "收入"
            isChangeNavTitleExpend = false
            fetchCategory_Income_Data(entityName: "Category_Income")
            collectionsView.reloadData()
        }else{
            navigationTitle.title = "支出"
            isChangeNavTitleExpend = true
            fetchCategory_Expend_Data(entityName: "Category_Expend")
            collectionsView.reloadData()
        }
    }
    
    
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

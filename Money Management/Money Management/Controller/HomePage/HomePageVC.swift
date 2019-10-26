//
//  HomePageVC.swift
//  Money Management
//
//  Created by CHEN Xuchu on 20/8/2019.
//  Copyright © 2019 CHEN Xuchu. All rights reserved.
//

import UIKit
import CoreData

private let identifiers = "TypeCell"
class HomePageVC: UIViewController,UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, UIPopoverPresentationControllerDelegate {
    
    var calculator = Property()
    var userDefault = UserDefaults()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var expendLable: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var popertyLabel: UILabel!
    
    @IBOutlet weak var showMonth: UIBarButtonItem!
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var viewContext: NSManagedObjectContext!
    
    var controller = NSFetchedResultsController<PopertyItem>()
    let fetchRequest = NSFetchRequest<PopertyItem>(entityName: "PopertyItem")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewContext = app.persistentContainer.viewContext
       fetchExpend()
        showMonth.title = PopoverDateVC.passNowMonth! + "月"
        
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refresh()

    }
    
    
    //MARK: - CoreData
    func fetchExpend(){
        
        //read data from plist
//        if let apiKey = Bundle.main.object(forInfoDictionaryKey: "PopoverDateYear") as? String {
//            print("\(apiKey)...")
//        }
      
//        if let month = userDefault.value(forKey: "PopeverDateMonth"){
//            print("\(month)...good")
//        }
        
        var years: String?
        var months: String?
        var endOfMonth: String?
        if let year = PopoverDateVC.changeYear{
            years = String(year)
        }
        //var month: String? = Date().month
        if let month = PopoverDateVC.passNowMonth{
            months = month
        }
        if let endMonth = PopoverDateVC.endOfMonth{
            endOfMonth = endMonth
        }
        
        var beginMonthOfYear: String?
        var endMonthOfYear: String?
        beginMonthOfYear = years!+"-"+months!+"-01"
        endMonthOfYear = years!+"-"+months!+"-"+endOfMonth!//remember to handle 30,31 day of month
        
        
        //var Stringdates = helper.FormatDate(dates: Date())
        let fromDate = Helper.stringConvertDate(string: beginMonthOfYear!)
        let toDate = Helper.stringConvertDate(string: endMonthOfYear!)
        
//        print("\(fromDate) : from")
//        print("\(toDate) : to")
        //for calculate poperty for each
        queryPropertyPrice(startDate: fromDate, endDate: toDate)
        calculator.calculateTotalProperty()
        expendLable.text = String(calculator.totalExpend!)
        incomeLabel.text = String(calculator.totalIncome!)
        popertyLabel.text = String(calculator.totalProperty!)
        
        //set bar title
        showMonth.title = months! + "月"
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "date >= %@ and date <= %@", fromDate as CVarArg, toDate as CVarArg)
         controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
           try controller.performFetch()
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
        
    }
    
    func queryPropertyPrice(startDate: Date, endDate: Date){
        var ExpendPrice = [Double]()
        var IncomePrice = [Double]()
        let fliter = NSFetchRequest<NSFetchRequestResult>(entityName: "PopertyItem")
        fliter.predicate = NSPredicate(format: "date >= %@ and date <= %@", startDate as CVarArg, endDate as CVarArg)
        do{
            let allData = try viewContext.fetch(fliter)
            
            for data in allData as! [PopertyItem]{
               
                if data.type == "支出"{
                    ExpendPrice.append(data.price)
                }else if data.type == "收入"{
                    IncomePrice.append(data.price)
                }
            }
            calculator.calculateTotalExpend(price:ExpendPrice)
            calculator.calculateTotalIncome(price: IncomePrice)
        }catch{
            print(error)
        }
    }
    
    
    //MARK: - TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return controller.sections!.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return self.controller.sections![section].numberOfObjects
        //return list.numberOfExpense
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifiers, for: indexPath) as! HomePaeTVC
        
        //coreData的数据模型的获取
        let list = self.controller.object(at: indexPath)
        if list.name != nil{
             cell.typeNmae.text = list.name
        }
       
       if list.image != nil{
            cell.typeImage.image =  UIImage(data: list.image! as Data)
        }
        
        if list.date != nil{
             cell.dataOfYear.text = Helper.FormatDate(dates: list.date as! Date)
        }
             cell.payPrice.text = String(list.price)
        if list.type != nil{
             cell.popertyType.text = list.type
        }
      // print(list.expend_ID)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                let id, name, desc: String?
                let image: Data?
                let price: Double?
                let date: Date?
                let type: String?
                let list = self.controller.object(at: indexPath)
   
                id = list.id
                name = list.name
                desc = list.desc ?? name
                image = list.image as Data?
                date = list.date as Date?
                price = list.price
                type = list.type
        
        
        let passDetailDate = Detail(id: id!, name: name!, image: image!, price: price!, desc: desc!, date: date!, type: type!)
        //print(passDetailDate!.detailName!)
        let destinationCV = storyboard?.instantiateViewController(withIdentifier: "detailCV") as! HomeDetailVC
        destinationCV.detail = passDetailDate
        
        show(destinationCV, sender: self)
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            do{
//                let array = try viewContext.fetch(fetchRequest)
//
                let ToDelete = self.controller.object(at: indexPath)
                viewContext.delete(ToDelete)
                
                try app.saveContext()
                fetchExpend() //fetch for update
            }catch{
               print("删除数据失败\(error.localizedDescription)")
            }
        }
        tableView.reloadData()
        
    }
    

    /// 当coredata存储的数据改变后调用的方法，这里直接更新tableview
    ///
    /// - Parameter controller: <#controller description#>
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        self.tableView.reloadData()
//    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
   
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
//        if type == .insert{
//            tableView.insertSections([sectionIndex], with: .fade)
//        }
//        if type == .delete{
//            tableView.deleteSections( [sectionIndex], with: .fade)
//        }
//    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let indexPath = indexPath {
            tableView.insertRows(at: [newIndexPath!], with: .left)
            }
            break
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case .update:
//            self.configureCell(cell: tableView.dequeueReusableCell(withIdentifier: identifiers), indexPath: indexPath)
            tableView.dequeueReusableCell(withIdentifier: identifiers, for: indexPath!)
            break
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .none)
            tableView.reloadSections([newIndexPath!.section], with: .none)
            break
        }
    }
    
    /// 当coredata存储的数据改变后调用的方法，这里直接更新tableview
    ///
    /// - Parameter controller: <#controller description#>
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    @IBAction func refresh(){
        fetchExpend()
        tableView.reloadData()
    }
    
    
    //MARK: - Popover
    // origin popover can run Ipad
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    //close popover window to run code
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        if PopoverDateVC.choseMonthFindd == true{
//            print("\(PopoverDateVC.changeYear)")
//            print("\(PopoverDateVC.passNowMonth)")
            do{
                //let ToSearch = self.controller.object(at: )
                refresh()
                
            }catch{
                print(error.localizedDescription)
            }
        }
        PopoverDateVC.choseMonthFindd = false
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        // for popover
        let popoverCtrl = segue.destination.popoverPresentationController
        if sender is UIButton{
            popoverCtrl?.sourceRect = (sender as! UIButton).bounds
        }
        else if sender is UIBarButtonItem{
            popoverCtrl?.barButtonItem = sender as? UIBarButtonItem
        }
        popoverCtrl?.delegate = self
        
        
//        if segue.identifier == "segue_homevc_to_detail"{
//            let vc = segue.destination as! HomeDetailVC
//            vc.detail = passDetailDate
//        }
    }
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}



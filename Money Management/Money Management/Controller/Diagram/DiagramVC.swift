//
//  DiagramVC.swift
//  Money Management
//
//  Created by CHEN Xuchu on 3/9/2019.
//  Copyright © 2019 CHEN Xuchu. All rights reserved.
//

import UIKit
import Charts
import CoreData

class DiagramVC: UIViewController, UITableViewDataSource, UITableViewDelegate{
   
    @IBOutlet var pieView: PieChartView!
    @IBOutlet weak var tableViews: UITableView!
    @IBOutlet weak var navtitle: UINavigationItem!
    
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var viewContext: NSManagedObjectContext!
    let fetchRequest = NSFetchRequest<PopertyItem>(entityName: "PopertyItem")
    
    var expendTypeNameSet = Set<String>()
    var incomeTypeNameSet = Set<String>()
    var expendTableList = [(name: String, images: Data, totalPrice: Double, percent: Float)]()
    var incomeTableList = [(name: String, images: Data, totalPrice: Double, percent: Float)]()
    var expendTotalPrice: Double = 0
    var incomeTotalPrice: Double = 0
    var poperty = Property()
    var isSwitchExpendTable: Bool? = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewContext = app.persistentContainer.viewContext
        
        // Do any additional setup after loading the view.
        
        fetchPoertyItem()
        
        //through set name to search data to save in tableviewArray
        for e in expendTypeNameSet.sorted(){
            searchToSaveTable(which:"Expend" ,nameType: e, pricesForPercent: expendTotalPrice)
        }
        for i in incomeTypeNameSet.sorted(){
            searchToSaveTable(which:"Income", nameType: i, pricesForPercent: incomeTotalPrice)
        }
        print(expendTotalPrice)
        print(incomeTotalPrice)
        
        PieChart.setupPieChart(pieView: pieView, NameSet: expendTypeNameSet)
        
//        for btn in 0 ..< months.count{
//            months[btn].setTitle(String(format: "%d 月", btn), for: .normal)
//        }
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navtitle.title = PopoverDateVC.passNowMonth! + "月"
    }
     

    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSwitchExpendTable!{
            return expendTableList.count
        }else{
            return incomeTableList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "typeCell", for: indexPath) as! DiagramTVC
        
        if isSwitchExpendTable!{
            let list = expendTableList[indexPath.row]
            cell.nameType.text = list.name + " " + String(format: "%0.2f", list.percent * 100) + "%"
            cell.toalPrice.text = String(list.totalPrice)
            if list.images != nil{
                cell.imageViews?.image = UIImage(data: list.images)
            }
            cell.progressPercent.progress = list.percent
        }else{
            let list = incomeTableList[indexPath.row]
            cell.nameType.text = list.name + " " + String(format: "%0.0f", list.percent * 100) + "%"
            cell.toalPrice.text = String(list.totalPrice)
            if list.images != nil{
                cell.imageViews!.image = UIImage(data: list.images)
                cell.imageViews!.layer.cornerRadius = 25
                cell.imageViews!.layer.masksToBounds = true
            }
            cell.progressPercent.progress = list.percent
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let passName: String?
        let totalPrices: Double?
        if isSwitchExpendTable!{
            let click = expendTableList[indexPath.row]
            passName = click.name
            totalPrices = click.totalPrice
        }else{
            let click = incomeTableList[indexPath.row]
            passName = click.name
            totalPrices = click.totalPrice
        }
        let vc = storyboard?.instantiateViewController(withIdentifier: "DiagramDetailVC") as! DiagramDetailVC
        vc.typeName = passName
        vc.totalPrice = totalPrices
        vc.isExpend = isSwitchExpendTable
        show(vc, sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    

    @IBAction func shiftOptionsOfType(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        let title = sender.titleForSegment(at: index)
        if index == 0{
            refreshAllPageData()
            PieChart.updataPieChartData(pieView: pieView)
            PieChart.setupPieChart(pieView: pieView, NameSet: expendTypeNameSet)
            isSwitchExpendTable = true
            tableViews.reloadData()
        }else if index == 1{
            refreshAllPageData()
            PieChart.updataPieChartData(pieView: pieView)
            PieChart.setupPieChart(pieView: pieView, NameSet: self.incomeTypeNameSet)
            isSwitchExpendTable = false
            tableViews.reloadData()
        }
        print(title)
    }
    
    func fetchPoertyItem(){
        
        var years: String?
        var months: String?
        if let year = PopoverDateVC.changeYear{
            years = String(year)
        }
        //var month: String? = Date().month
        if let month = PopoverDateVC.passNowMonth{
            months = month
        }
        var beginMonthOfYear: String?
        var endMonthOfYear: String?
        beginMonthOfYear = years!+"-"+months!+"-01"
        endMonthOfYear = years!+"-"+months!+"-31"
        //var Stringdates = helper.FormatDate(dates: Date())
        let fromDate = Helper.stringConvertDate(string: beginMonthOfYear!)
        let toDate = Helper.stringConvertDate(string: endMonthOfYear!)
        
        
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "date >= %@ and date <= %@", fromDate as CVarArg, toDate as CVarArg)
        
        do {
            let result = try viewContext.fetch(fetchRequest)
            for data in result as [PopertyItem] {
                if data.type == "支出"{
                    expendTypeNameSet.insert(data.name!)
                    expendTotalPrice += data.price
                }else if data.type == "收入"{
                    incomeTypeNameSet.insert(data.name!)
                    incomeTotalPrice += data.price
                }
            }
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
        
        
    }
    
    func searchToSaveTable(which: String? = "Expend", nameType: String, pricesForPercent: Double){
        var years: String?
        var months: String?
        if let year = PopoverDateVC.changeYear{
            years = String(year)
        }
        //var month: String? = Date().month
        if let month = PopoverDateVC.passNowMonth{
            months = month
        }
        var beginMonthOfYear: String?
        var endMonthOfYear: String?
        beginMonthOfYear = years!+"-"+months!+"-01"
        endMonthOfYear = years!+"-"+months!+"-31"
        //var Stringdates = helper.FormatDate(dates: Date())
        let fromDate = Helper.stringConvertDate(string: beginMonthOfYear!)
        let toDate = Helper.stringConvertDate(string: endMonthOfYear!)
        
        
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "date >= %@ and date <= %@ and name==%@", fromDate as CVarArg, toDate as CVarArg, nameType)
        
        var prices = [Double]()
        var image: Data?
        do {
            let result = try viewContext.fetch(fetchRequest)
            if result[0].image != nil{
                image = result[0].image as Data?
            }
            for data in result as [PopertyItem] {
                prices.append(data.price)
            }
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
        let toatlPrice = poperty.calculateEachTypeTotalPrice(total: prices)
        let percent = toatlPrice / pricesForPercent
        if which == "Expend"{
        expendTableList.append((name: nameType, images: image!, totalPrice: toatlPrice, percent: Float(percent)))
        }else if which == "Income"{
        incomeTableList.append((name: nameType, images: image!, totalPrice: toatlPrice, percent: Float(percent)))
        }
    }
    
    func refreshAllPageData(){
        expendTypeNameSet.removeAll()
        incomeTypeNameSet.removeAll()
        expendTotalPrice = 0
        incomeTotalPrice = 0
        expendTableList.removeAll()
        incomeTableList.removeAll()
        
        //insert each data name to set
        fetchPoertyItem()
        //through set name to search data to save in tableviewArray
        for e in expendTypeNameSet.sorted(){
            searchToSaveTable(which:"Expend" ,nameType: e, pricesForPercent: expendTotalPrice)
        }
        for i in incomeTypeNameSet.sorted(){
            searchToSaveTable(which:"Income", nameType: i, pricesForPercent: incomeTotalPrice)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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



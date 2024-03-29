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

struct ExpendLimited {
    var typeName: String
    var price: Double
}

struct IncomeLimited {
    var typeName: String
    var price: Double
}

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
    
    var expendLimitedPieChart = [ExpendLimited]()
    var incomeLimitedPieChart = [IncomeLimited]()
    var expendDataCount: Int = 0
    var incomeDataCount: Int = 0
    var expendlimitedCount : Int = 0
    var incomelimitedCount : Int = 0
    var expend4ItemPrice: Double? = 0
    var income4ItemPrice: Double? = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewContext = app.persistentContainer.viewContext
        
        // Do any additional setup after loading the view.
        
        //get each type to save to set
        fetchPoertyItem()
        
        expendlimitedCount = expendTypeNameSet.count //set 4 if num is big than 4
        incomelimitedCount = incomeTypeNameSet.count
        
        //through set name to search data to save in tableviewArray
        for e in expendTypeNameSet.sorted(){
            searchToSaveTable(which:"Expend" ,nameType: e, pricesForPercent: expendTotalPrice)
        }
        for i in incomeTypeNameSet.sorted(){
            searchToSaveTable(which:"Income", nameType: i, pricesForPercent: incomeTotalPrice)
        }
        
        print(expendTotalPrice)
        print(incomeTotalPrice)
        
        PieChart.setupPieChart(pieView: pieView, NameSet: expendLimitedPieChart)
        
//        print(">>testing")
//        for index in expendLimitedPieChart{
//            print(index.self)
//        }
//        for index in incomeLimitedPieChart{
//            print(index.self)
//        }
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navtitle.title = PopoverDateVC.passNowMonth! + NSLocalizedString("month", comment: "")
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
            PieChart.setupPieChart(pieView: pieView, NameSet: expendLimitedPieChart)
            isSwitchExpendTable = true
            tableViews.reloadData()
        }else if index == 1{
            refreshAllPageData()
            PieChart.updataPieChartData(pieView: pieView)
            PieChart.setupPieChart(pieView: pieView, NameSet: incomeLimitedPieChart)
            isSwitchExpendTable = false
            tableViews.reloadData()
        }
        print(title)
    }
    
    func fetchPoertyItem(){
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
        endMonthOfYear = years!+"-"+months!+"-"+endOfMonth!
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
        endMonthOfYear = years!+"-"+months!+"-"+endOfMonth!
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
        let totalPrice = poperty.calculateEachTypeTotalPrice(total: prices)
        let percent = totalPrice / pricesForPercent
        
        
        if which == "Expend"{
        expendTableList.append((name: nameType, images: image!, totalPrice: totalPrice, percent: Float(percent)))
            
            //limited to show 5 item in piechart of expend section
            if expendDataCount < expendlimitedCount{
                expendLimitedPieChart.append(ExpendLimited(typeName: nameType, price: totalPrice))
                    expendDataCount += 1
                if expendDataCount == 3{ //set it over 4
                    expendlimitedCount = 4
                }
                expend4ItemPrice! += totalPrice
            }else if expendDataCount == 4{
                var leftPrice: Double? = 0
                leftPrice = expendTotalPrice - expend4ItemPrice!
                expendLimitedPieChart.append(ExpendLimited(typeName: "Other", price: leftPrice!))
                expendDataCount += 1
            }else{
                print("other name in expendPart type was not saved")
            }
            
        }else if which == "Income"{
        incomeTableList.append((name: nameType, images: image!, totalPrice: totalPrice, percent: Float(percent)))
            
            //limited to show 5 item in piechart of income section
            if incomeDataCount < incomelimitedCount{
                incomeLimitedPieChart.append(IncomeLimited(typeName: nameType, price: totalPrice))
                    incomeDataCount += 1
                    income4ItemPrice! += totalPrice
                if incomeDataCount == 3{ //set it if over 4
                    incomelimitedCount = 4
                }
                }else if incomeDataCount == 4{
                    var leftPrice: Double? = 0
                    leftPrice = incomeTotalPrice - income4ItemPrice!
                incomeLimitedPieChart.append(IncomeLimited(typeName: "Other", price: leftPrice!))
                    incomeDataCount += 1
                }else{
                    print("left name in IncomePart type was not saved")
                }
        }
    }
    
    
    
    func refreshAllPageData(){
        expendTypeNameSet.removeAll()
        incomeTypeNameSet.removeAll()
        expendTotalPrice = 0
        incomeTotalPrice = 0
        expendDataCount = 0
        incomeDataCount = 0
        expendlimitedCount = 0
        incomelimitedCount = 0
        expend4ItemPrice = 0
        income4ItemPrice = 0
        expendLimitedPieChart.removeAll()
        incomeLimitedPieChart.removeAll()
        expendTableList.removeAll()
        incomeTableList.removeAll()
        
        //insert each data name to set
        fetchPoertyItem()
        
        expendlimitedCount = expendTypeNameSet.count
        incomelimitedCount = incomeTypeNameSet.count
        
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



//
//  DiagramDetailVC.swift
//  Money Management
//
//  Created by CHEN Xuchu on 5/9/2019.
//  Copyright © 2019 CHEN Xuchu. All rights reserved.
//

import UIKit
import Charts
import CoreData
class DiagramDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var typeName: String?
    var totalPrice: Double?
    var isExpend: Bool?
    @IBOutlet var lineChart: LineChartView!
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var averageDatePriceLable: UILabel!
    @IBOutlet weak var totalPriceLable: UILabel!
    let app = UIApplication.shared.delegate as! AppDelegate
    var viewContext: NSManagedObjectContext!
    let fetchRequest = NSFetchRequest<PopertyItem>(entityName: "PopertyItem")
    var expendTableList = [(name: String, images: Data, Price: Double, percent: Float, date: Date)]()
    var incomeTableList = [(name: String, images: Data, Price: Double, percent: Float, date: Date)]()
    
    var expendLineChartData = [LineChart]()
    var incomeLineChartData = [LineChart]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewContext = app.persistentContainer.viewContext
        
        //for each date not repeat and calculate same date it's total price,
        for dayOf31 in 1...31{
            expendLineChartData.append(LineChart(day: dayOf31, price: 0, ishaveData: false))
            incomeLineChartData.append(LineChart(day: dayOf31, price: 0, ishaveData: false))
        }
        
        if let name = typeName, let totalPrices = totalPrice{
            searchToSaveTable(nameType: name, pricesForPercent: totalPrices)
        }
        nameLable.text = typeName!
        averageDatePriceLable.text = String(format: "%0.1f", totalPrice! / 30)
        totalPriceLable.text = String(format: "%0.1f", totalPrice!)
        
        if isExpend == true{
            LineChart.setupLineChart(lineChart: lineChart, price: expendLineChartData)
        }else{
            LineChart.setupLineChart(lineChart: lineChart, price: incomeLineChartData)
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isExpend == true{
            return expendTableList.count
        }else{
            return incomeTableList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "diagramdetailCell", for: indexPath) as! DiagramDetailTVC
        
         if isExpend == true{
            let list = expendTableList[indexPath.row]
            cell.nameLable.text = list.name + " " + String(format: "%0.0f", list.percent * 100) + "%"
            if list.images != nil{
            cell.imagesView.image = UIImage(data: list.images)
            cell.imagesView.layer.cornerRadius = 25
            cell.imagesView.layer.masksToBounds = true
            }
            cell.dateLable.text = Helper.FormatDate(dates: list.date)
            cell.priceLable.text = String(list.Price)
            cell.precent.progress = list.percent
         }else{
            let list = incomeTableList[indexPath.row]
            cell.nameLable.text = list.name + " " + String(format: "%0.0f", list.percent * 100) + "%"
            if list.images != nil{
                cell.imagesView.image = UIImage(data: list.images)
                cell.imagesView.layer.cornerRadius = 25
                cell.imagesView.layer.masksToBounds = true
            }
            cell.dateLable.text = Helper.FormatDate(dates: list.date)
            cell.priceLable.text = String(list.Price)
            cell.precent.progress = list.percent
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
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
        

        
        do {
            let result = try viewContext.fetch(fetchRequest)
            
            for data in result as [PopertyItem] {
                if data.type == "支出"{
                    let percent = data.price / pricesForPercent
                    let image = data.image! as Data
                    let date = data.date! as Date
                    let price = data.price
                    expendTableList.append((name: nameType, images: image , Price: price, percent: Float(percent), date: date))
                    
                    let dayOfDate = Helper.getComponentOfDate(Date: date, WhichComponent: "day")
                    
                    for data in expendLineChartData{
                        if dayOfDate == data.day{
                            data.price += price
                            data.ishaveData = true
                        }
                    }
                    
                    expendLineChartData.append(LineChart(day: dayOfDate, price: price, ishaveData: true))
                    
                }else if data.type == "收入"{
                    let percent = data.price / pricesForPercent
                    let image = data.image! as Data
                    let date = data.date! as Date
                    let price = data.price
                    incomeTableList.append((name: nameType, images: image , Price: price, percent: Float(percent), date: date))
                    
                    let dayOfDate = Helper.getComponentOfDate(Date: date, WhichComponent: "day")
                    
                    for data in incomeLineChartData{
                        if dayOfDate == data.day{
                            data.price += price
                            data.ishaveData = true
                        }
                    }
                    
                    incomeLineChartData.append(LineChart(day: dayOfDate, price: price, ishaveData: true))
                    
                    
                }else{
                    return
                }
            }
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
        
        
        
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

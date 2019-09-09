//
//  ExportVC.swift
//  Money Management
//
//  Created by CHEN Xuchu on 8/9/2019.
//  Copyright © 2019 CHEN Xuchu. All rights reserved.
//

import UIKit
import CoreData
class ExportVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var format = ["Excel", "Json"]
    @IBOutlet weak var startDate: UIDatePicker!
    @IBOutlet weak var endtDate: UIDatePicker!
    
    var theStartDate: Date?
    var theEndDate: Date?
    var theExportFormat: String?
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var viewContext: NSManagedObjectContext!
    let fetchRequest = NSFetchRequest<PopertyItem>(entityName: "PopertyItem")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewContext = app.persistentContainer.viewContext
        // Do any additional setup after loading the view.
        setDate()
        
    }
    
    func setDate(){
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
        
        let start = Helper.stringConvertDate(string: beginMonthOfYear!)
        let end = Helper.stringConvertDate(string: endMonthOfYear!)
        startDate.setDate(start, animated: true)
        endtDate.setDate(end, animated: true)
        setDefaultValue(start: start, end: end)
    }
    
    func setDefaultValue(start: Date, end: Date, format: String = "Json"){
        theStartDate = start
        theEndDate = end
        theExportFormat = format
    }
    
    func exportFormat(TypeOfFormat: String){
        let fileName = "Tasks.csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        var csvText = "Date,Export/Income,Category,Notes, total\n"
        
        
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
            for task in result as [PopertyItem] {
                
                //add it to the csv file.
                let date = Helper.FormatDate(dates: task.date! as Date)
                let type = String(format: "%@ ", task.type!)
                let name = String(format: "%@ ", task.name!)
                let desc = String(format: "%@ ", task.desc!)
                let newLine = "\(date),\(type),\(name),\(desc),\(task.price)\n"
                csvText.append(contentsOf: newLine)
            }
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
        
        // creating the csv file
        do {
            try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
            
            //exporting csv file and share it
            let vc = UIActivityViewController(activityItems: [path!], applicationActivities: [])
            vc.excludedActivityTypes = [
                UIActivity.ActivityType.airDrop,
                UIActivity.ActivityType.assignToContact,
                UIActivity.ActivityType.copyToPasteboard,
                UIActivity.ActivityType.mail,
                UIActivity.ActivityType.message,
                UIActivity.ActivityType.openInIBooks,
                UIActivity.ActivityType.postToFacebook,
                UIActivity.ActivityType.postToFlickr,
                UIActivity.ActivityType.postToWeibo,
                UIActivity.ActivityType.postToTencentWeibo,
                UIActivity.ActivityType.postToTwitter,
                UIActivity.ActivityType.postToVimeo,
                UIActivity.ActivityType.print,
                UIActivity.ActivityType.saveToCameraRoll,
                UIActivity.ActivityType.markupAsPDF
            ]
            present(vc, animated: true, completion: nil)
            
            
        } catch {
            print("Failed to create file")
            print("\(error)")
        }
        
        
    }
    
    @IBAction func sureExport(_ sender: UIButton){
        exportFormat(TypeOfFormat: "")
    }
    
    

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return format.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return format[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(format[row])
    }
    
    @IBAction func startDate(_ sender: UIDatePicker){
        let startdate = Helper.FormatDate(dates: sender.date)
        print(startdate)
    }
    
    @IBAction func endDate(_ sender: UIDatePicker){
        let enddate = Helper.FormatDate(dates: sender.date)
        print(enddate)
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

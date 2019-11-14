//
//  NotificationVC.swift
//  Money Management
//
//  Created by CHEN Xuchu on 10/9/2019.
//  Copyright © 2019 CHEN Xuchu. All rights reserved.
//

import UIKit
import UserNotifications
import CoreData
private var indentifierCell = "notificationCell"
class NotificationVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var chooseTimeView: UIView!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var notificationTable: UITableView!
   
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var viewContext: NSManagedObjectContext!
    var controller = NSFetchedResultsController<Notifications>()
    let fetchRequest = NSFetchRequest<Notifications>(entityName: "Notifications")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewContext = app.persistentContainer.viewContext
        // Do any additional setup after loading the view.
       // sendNotification()
        chooseTimeView.alpha = 0 //hide
        
        fetch()
        
    }
    
    
    
    @IBAction func showAndHideView(_ sender: UIButton){
        chooseTimeView.animateToggleAlpha()
    }
    
    @IBAction func setTime(_ sender: UIButton){
        let time = timePicker.date
        print(time)
        let currentItem = fecthCount()//core data
        if limited(Maxitem: 5, NowItem: currentItem){
            let Dates = NSEntityDescription.insertNewObject(forEntityName: "Notifications", into: viewContext) as! Notifications
            Dates.id = UUID()
            Dates.isDelete = false
            Dates.isPend = true
            Dates.time = time as NSDate
            do {
                try viewContext.save()
                AlertMessages.showSuccessfulMessage(title: "Success", msg: "Save Sucessfully", vc: self)
            } catch {
                fatalError("Failure to save context: \(error)")
            }
            
            let settedTime = time
            let settedHour = Helper.getComponentOfDate(Date: settedTime, WhichComponent: "hour")
            let settedMinute = Helper.getComponentOfDate(Date: settedTime, WhichComponent: "minute")
            let settedSecond = Helper.getComponentOfDate(Date: settedTime, WhichComponent: "second")
            print("setted hour: \(settedHour) , minute: \(settedMinute), second: \(settedSecond)")
            
                sendNotification(hour: settedHour, minute: settedMinute, second: settedSecond)
            
            
        }else{
            print("item exceed 5")
        }
        
        fetch()
        notificationTable.reloadData()
        
    }
    
    
    func limited(Maxitem: Int = 5, NowItem: Int) -> Bool{
        if NowItem < Maxitem{
            return true
        }
        return false
    }
    
    
    //MARK: - Local Notification
    func sendNotification(hour: Int, minute: Int, second: Int){
        //1.
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge, .carPlay], completionHandler: { (granted, error) in
            if granted {
                print("允許")
            } else {
                print("不允許")
            }
        })
        
        //2.
        let content = UNMutableNotificationContent()
        content.title = "MMoney Reminder"
        content.body = "It is time to record your property!"
        content.sound = UNNotificationSound.default
        
        //3.Deliver the notification in five seconds.
//        let date = Date().addingTimeInterval(5)
//        let dateComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        var dateComponent = DateComponents()
        dateComponent.hour = hour
        dateComponent.minute = minute
        dateComponent.second = second
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        
       // let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(trigarSecond), repeats: false) //Time-Based triggar
        
        //4. create request
        let uiustring = UUID().uuidString
        let request = UNNotificationRequest(identifier: uiustring, content: content, trigger: trigger) // Schedule the notification.
        
        //5.register the request
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error : Error?) in
            if let theError = error {
                // Handle any errors
                print(theError)
            }
        }
        
        
    }
    
    //MARK: - Core Data
    func fetch(){
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "time", ascending: true)]
       // fetchRequest.predicate = NSPredicate(format: "date == %@")
        controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try controller.performFetch()
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
    }
    
    func fecthCount() -> Int{
        var count = 0
            do{
                let allData = try viewContext.fetch(Notifications.fetchRequest())
                count = allData.count
            }catch{
                print("fail to get notification total count")
            }
        return count
    }
    
    
    //MARK: - TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return controller.sections!.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.controller.sections![section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: indentifierCell, for: indexPath) as! NotificationTVC
        let it = self.controller.object(at: indexPath)
        cell.dateLabel.text = Helper.FormatTime(time: it.time! as Date)
        //cell.dateLabel.tag = indexPath.row
        
        //configure button
        cell.isdeleteButton.isSelected = it.isDelete
        cell.isdeleteButton.tag = indexPath.row
        cell.isdeleteButton.addTarget(self, action: #selector(deleteWhichNotification(_:)), for: .touchUpInside)
        
        //configure switch
        cell.isOpenSwitch.setOn(it.isPend, animated: true)
        cell.isOpenSwitch.tag = indexPath.row
        cell.isOpenSwitch.addTarget(self, action: #selector(self.switchChanged(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func switchChanged(_ sender : UISwitch!){
        print("table row switch Changed \(sender.tag)")
        print("The switch is \(sender.isOn ? "ON" : "OFF")")
        
    }
   
    @objc func deleteWhichNotification(_ sender: UIButton!){
        print("table row button tag \(sender.tag)")
        print("The button is \(sender.isSelected ? "True" : "False")")
    }
    
    
    
    
    
//    //MARK: - TableView connect Core data
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        notificationTable.beginUpdates()
//    }
//
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//        switch type {
//        case .insert:
//            notificationTable.insertRows(at: [newIndexPath!], with: .fade)
//        case .delete:
//            notificationTable.deleteRows(at: [indexPath!], with: .fade)
//        case .update:
//            notificationTable.reloadRows(at: [indexPath!], with: .fade)
//        case .move:
//            notificationTable.moveRow(at: indexPath!, to: newIndexPath!)
//        default:
//            notificationTable.reloadData()
//        }
//    }
//
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        notificationTable.endUpdates()
//    }
    
    
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

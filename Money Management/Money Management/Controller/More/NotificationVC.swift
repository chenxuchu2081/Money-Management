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
        sendNotification()
        chooseTimeView.alpha = 0 //hide
        
        fetch()
        
    }
    
    
    
    @IBAction func showAndHideView(_ sender: UIButton){
        chooseTimeView.animateToggleAlpha()
    }
    
    @IBAction func setTime(_ sender: UIButton){
        let time = timePicker.date
        print(time)
        
        let Dates = NSEntityDescription.insertNewObject(forEntityName: "Notifications", into: viewContext) as! Notifications
        Dates.id = UUID()
        Dates.isDelete = false
        Dates.isPend = false
        Dates.time = time as NSDate
        do {
            try viewContext.save()
            AlertMessages.showSuccessfulMessage(title: "Success", msg: "Save Sucessfully", vc: self)
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        fetch()
        notificationTable.reloadData()
        
    }
    
    func sendNotification(){
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
        content.title = "hello"
        content.body = "hello body"
        content.sound = UNNotificationSound.default
        
        //3.Deliver the notification in five seconds.
        let date = Date().addingTimeInterval(5)
        let dateComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        
        //4. create request
        let uiustring = UUID().uuidString
        let request = UNNotificationRequest(identifier: uiustring, content: content, trigger: trigger) // Schedule the notification.
        
        //5.register the request
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error : Error?) in
            if let theError = error {
                // Handle any errors
            }
        }
        
        
    }
    
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
    
    
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<Notifications>) {
//        notificationTable.beginUpdates()
//    }
//
//    func controller(_ controller: NSFetchedResultsController<Notifications>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
//        switch type {
//        case .insert:
//            notificationTable.insertSections(IndexSet(integer: sectionIndex), with: .fade)
//        case .delete:
//            notificationTable.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
//        case .move:
//            break
//        case .update:
//            break
//        }
//    }
//
//    func controller(_ controller: NSFetchedResultsController<Notifications>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//        switch type {
//        case .insert:
//            notificationTable.insertRows(at: [newIndexPath!], with: .fade)
//        case .delete:
//            notificationTable.deleteRows(at: [indexPath!], with: .fade)
//        case .update:
//            notificationTable.reloadRows(at: [indexPath!], with: .fade)
//        case .move:
//            notificationTable.moveRow(at: indexPath!, to: newIndexPath!)
//        }
//    }
//
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<Notifications>) {
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

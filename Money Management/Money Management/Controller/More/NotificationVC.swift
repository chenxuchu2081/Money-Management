//
//  NotificationVC.swift
//  Money Management
//
//  Created by CHEN Xuchu on 10/9/2019.
//  Copyright © 2019 CHEN Xuchu. All rights reserved.
//

import UIKit

private var indentifierCell = "notificationCell"
class NotificationVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var list = [(isDelete: Bool, date: Date, isOpenNotication: Bool)]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        list.append((false, Date(), false))
        list.append((false, Date(), false))
        list.append((false, Date(), false))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: indentifierCell, for: indexPath) as! NotificationTVC
        let it = list[indexPath.row]
        cell.dateLabel.text = Helper.FormatDate(dates: it.date)
        
        return cell
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

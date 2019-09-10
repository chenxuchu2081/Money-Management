//
//  NotificationTVC.swift
//  Money Management
//
//  Created by CHEN Xuchu on 10/9/2019.
//  Copyright © 2019 CHEN Xuchu. All rights reserved.
//

import UIKit

class NotificationTVC: UITableViewCell {

    @IBOutlet weak var isdeleteButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var isOpenSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

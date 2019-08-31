//
//  HomePaeTVC.swift
//  Money Management
//
//  Created by CHEN Xuchu on 20/8/2019.
//  Copyright © 2019 CHEN Xuchu. All rights reserved.
//

import UIKit

class HomePaeTVC: UITableViewCell {

    @IBOutlet weak var typeNmae : UILabel!
    @IBOutlet weak var typeImage: UIImageView!
    @IBOutlet weak var payPrice: UILabel!
    @IBOutlet weak var dataOfYear: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

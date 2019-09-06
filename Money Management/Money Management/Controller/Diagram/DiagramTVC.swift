//
//  DiagramTVC.swift
//  Money Management
//
//  Created by CHEN Xuchu on 4/9/2019.
//  Copyright © 2019 CHEN Xuchu. All rights reserved.
//

import UIKit

class DiagramTVC: UITableViewCell {

    @IBOutlet weak var nameType: UILabel!
    @IBOutlet weak var imageViews: UIImageView?
    @IBOutlet weak var toalPrice: UILabel!
    @IBOutlet weak var progressPercent: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

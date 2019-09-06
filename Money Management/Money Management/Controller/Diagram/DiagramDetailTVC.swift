//
//  DiagramDetailTVC.swift
//  Money Management
//
//  Created by CHEN Xuchu on 6/9/2019.
//  Copyright © 2019 CHEN Xuchu. All rights reserved.
//

import UIKit

class DiagramDetailTVC: UITableViewCell {

    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var imagesView: UIImageView!
    @IBOutlet weak var priceLable: UILabel!
    @IBOutlet weak var precent: UIProgressView!
    @IBOutlet weak var dateLable: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

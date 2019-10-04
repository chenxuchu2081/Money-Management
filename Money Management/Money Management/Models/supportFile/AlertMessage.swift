//
//  AlertMessage.swift
//  Money Management
//
//  Created by CHEN Xuchu on 10/9/2019.
//  Copyright © 2019 CHEN Xuchu. All rights reserved.
//

import Foundation
import UIKit

class AlertMessages{
    
    static public func showErrorAlert(title: String, msg: String, vc: UIViewController){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Got it!💪", style: .cancel, handler: nil))
        
        let imageTilte = UIImage(named: "cancel.png")
        let imgViewTitle = UIImageView(frame: CGRect(x: 120, y: -15, width: 30, height: 30))
        imgViewTitle.image = imageTilte
        alert.view.addSubview(imgViewTitle)
        
        vc.present(alert, animated: true, completion: nil)
    
    }
    
    static public func alarming(text: String, vc: UIViewController){
        let alert = UIAlertController(title: "注意⚠️", message: text, preferredStyle: .alert)
        let action = UIAlertAction(title: "Got it！👌", style: .cancel, handler: nil)
        alert.addAction(action)
        vc.present(alert, animated:  true, completion: nil)
    }
    
    static public func showSuccessfulMessage(title: String, msg: String, vc: UIViewController){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "Got it！💪", style: .cancel, handler: nil)
        
        let imageTilte = UIImage(named: "successful.png")
        let imgViewTitle = UIImageView(frame: CGRect(x: 120, y: -15, width: 30, height: 30))
        imgViewTitle.image = imageTilte
        alert.view.addSubview(imgViewTitle)
        
        alert.addAction(action)
        vc.present(alert, animated:  true, completion: nil)
    }
    
}

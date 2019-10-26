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
    
    static public func showToast(msg: String, seconds: Double, vc: UIViewController){
        let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor(displayP3Red: 88.0/255, green: 204.0/255, blue: 237.0/255, alpha: 0.5)
        //alert.view.alpha = 0.5
        alert.view.layer.cornerRadius = 15
        
        //style font
        let toastLb = UILabel()
        toastLb.numberOfLines = 0
        toastLb.lineBreakMode = .byWordWrapping
        toastLb.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toastLb.textColor = UIColor.white
        toastLb.layer.cornerRadius = 10.0
        toastLb.textAlignment = .center
        toastLb.font = UIFont.systemFont(ofSize: 15.0)
        toastLb.layer.masksToBounds = true
        alert.view.addSubview(toastLb)
        
        vc.present(alert, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds){
            alert.dismiss(animated: true, completion: nil)
        }
        
    }
    
    
}

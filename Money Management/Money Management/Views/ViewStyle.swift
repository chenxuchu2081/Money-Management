//
//  ViewStyle.swift
//  Money Management
//
//  Created by CHEN Xuchu on 8/9/2019.
//  Copyright © 2019 CHEN Xuchu. All rights reserved.
//

import Foundation
import UIKit

class ViewStyle{
    
    static func border(in layer: CALayer){
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 2
    }
    
    static func shadow(in layer: CALayer){
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 5,height: 5)
        layer.shadowRadius = 10.0
    }
    
    static func cornerRadius(in layer: CALayer){
        layer.cornerRadius = 10
    }
    
     static func rotate() -> CGAffineTransform{
        return CGAffineTransform(rotationAngle: 45/180 * CGFloat.pi)
    }
    
    static func scale() -> CGAffineTransform{
        return CGAffineTransform(scaleX: 0.5, y: 0.5)
    }
    
//    static func AmzingView(myView: UIView){
//        myView.layer.shadowPath =
//              UIBezierPath(roundedRect: myView.bounds,
//              cornerRadius: myView.layer.cornerRadius).cgPath
//        myView.layer.shadowColor = UIColor.black.cgColor
//        myView.layer.shadowOpacity = 0.8
//        myView.layer.shadowOffset = CGSize(width: 10, height: 10)
//        myView.layer.shadowRadius = 5
//        myView.layer.masksToBounds = true
//    }
    
}

extension UIView {
    
    func animateToggleAlpha() {
        UIView.animate(withDuration: 0.5) {
            self.alpha = self.alpha == 1 ? 0 : 1
        }
    }
    
}

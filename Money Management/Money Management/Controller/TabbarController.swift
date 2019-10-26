//
//  TabbarController.swift
//  Money Management
//
//  Created by CHEN Xuchu on 7/10/2019.
//  Copyright © 2019 CHEN Xuchu. All rights reserved.
//

import UIKit

class TabbarController: UITabBarController, UITabBarControllerDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        delegate = self
        
    }
    
   
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let index = item.tag
        let title = item.title
        let tagAndTitle = (index, title)
        switch tagAndTitle {
        case (1, "Home"):
            print("testing tab bar:\(index), title: \(title)")
        case (2, "Chart"):
            print("testing tab bar:\(index), title: \(title)")
            
        case (3, "Category"):
            print("testing tab bar:\(index), title: \(title)")
        case (4, "Export"):
            print("testing tab bar:\(index), title: \(title)")
        case(5, "Setting"):
            print("testing tab bar:\(index), title: \(title)")
        default:
            print("testing tab bar not working")
        }
        
    }
//    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//       let index =  tabBarController.selectedIndex
//        
//        
//        
//    }
    
   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

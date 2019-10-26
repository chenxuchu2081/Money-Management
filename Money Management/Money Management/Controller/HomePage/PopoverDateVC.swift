//
//  PopoverDateVC.swift
//  Money Management
//
//  Created by CHEN Xuchu on 25/8/2019.
//  Copyright © 2019 CHEN Xuchu. All rights reserved.
//

import UIKit

class PopoverDateVC: UIViewController {

    var years = [2000:"2000" ,2001:"2001" ,2002:"2002",2003:"2003" ,2004:"2004",2005:"2005" ,2006:"2006" ,2007:"2007",2008:"2008" ,2009:"2009",2010:"2010" ,2011:"2011" ,2012:"2012",2013:"2013" ,2014:"2014",2015:"2015" ,2016:"2016" ,2017:"2017",2018:"2018" ,2019:"2019",2020:"2020" ,2021:"2021" ,2022:"2022",2023:"2023" ,2024:"2024",2025:"2025" ,2026:"2026" ,2027:"2027",2028:"2028"]
    
    static var changeYear: Int? = 2019
    static var passNowMonth: String? = Date().month
    static var startOfMonth: String? = "01"
    static var endOfMonth: String? = "29"
    static var choseMonthFindd: Bool? = false
    
    var currentYear: String?
    let userDefault = UserDefaults()
    @IBOutlet weak var yearlabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       if let year = PopoverDateVC.changeYear{
             yearlabel.text = String(year)
        }
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @IBAction func previous(_ sender: UIButton){
        if PopoverDateVC.changeYear != nil{
            yearlabel.text = years[PopoverDateVC.changeYear! - 1]
            PopoverDateVC.changeYear! -= 1
            
        }
        
    }
    
    @IBAction func next(_ sender: UIButton){
        if PopoverDateVC.changeYear != nil{
            yearlabel.text = years[PopoverDateVC.changeYear! + 1]
            PopoverDateVC.changeYear! += 1
            
        }
    }
    
    @IBAction func selectMonth(_ sender: UIButton) {
        print(sender.tag)
        let months = sender.tag
        
//        let month = String(sender.tag)
//        userDefault.set(month, forKey: "PopeverDateMonth")
//        userDefault.set(currentYear, forKey: "PopeverDateYear")
        
        
        switch months {
        case 1:
            PopoverDateVC.passNowMonth = "1"
            PopoverDateVC.endOfMonth = "31"
            PopoverDateVC.choseMonthFindd = true
            break
        case 2:
            PopoverDateVC.passNowMonth = "2"
            PopoverDateVC.endOfMonth = "28"
            PopoverDateVC.choseMonthFindd = true
            break
        case 3:
            PopoverDateVC.passNowMonth = "3"
            PopoverDateVC.endOfMonth = "31"
            PopoverDateVC.choseMonthFindd = true
            break
        case 4:
            PopoverDateVC.passNowMonth = "4"
            PopoverDateVC.endOfMonth = "30"
            PopoverDateVC.choseMonthFindd = true
            break
        case 5:
            PopoverDateVC.passNowMonth = "5"
            PopoverDateVC.endOfMonth = "31"
            PopoverDateVC.choseMonthFindd = true
            break
        case 6:
            PopoverDateVC.passNowMonth = "6"
            PopoverDateVC.endOfMonth = "30"
            PopoverDateVC.choseMonthFindd = true
            break
        case 7:
            PopoverDateVC.passNowMonth = "7"
            PopoverDateVC.endOfMonth = "31"
            PopoverDateVC.choseMonthFindd = true
            break
        case 8:
            PopoverDateVC.passNowMonth = "8"
            PopoverDateVC.endOfMonth = "31"
            PopoverDateVC.choseMonthFindd = true
            break
        case 9:
            PopoverDateVC.passNowMonth = "9"
            PopoverDateVC.endOfMonth = "30"
            PopoverDateVC.choseMonthFindd = true
            break
        case 10:
            PopoverDateVC.passNowMonth = "10"
            PopoverDateVC.endOfMonth = "31"
            PopoverDateVC.choseMonthFindd = true
            break
        case 11:
            PopoverDateVC.passNowMonth = "11"
            PopoverDateVC.endOfMonth = "30"
            PopoverDateVC.choseMonthFindd = true
            break
        case 12:
            PopoverDateVC.passNowMonth = "12"
            PopoverDateVC.endOfMonth = "31"
            PopoverDateVC.choseMonthFindd = true
            break
        default:
            PopoverDateVC.passNowMonth = "01"
            PopoverDateVC.endOfMonth = "31"
            PopoverDateVC.choseMonthFindd = true
            break
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//        if segue.identifier == "segue_vc_to_PoperverDate"{
//            let vc = segue.destination as! HomePageVC
//            vc.popover = popovers
//        }
//    }
 

}

extension Date {
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        let date = dateFormatter.date(from: dateFormatter.string(from: self))
        let component = dateFormatter.calendar.component(.month, from: date!)
        let toStringMonth = String(component)
        return toStringMonth
        //return dateFormatter.string(from: self)
    }
    
   
}




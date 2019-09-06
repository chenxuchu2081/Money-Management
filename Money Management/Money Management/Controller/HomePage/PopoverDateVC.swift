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
    //var month: String? = Date().month
    static var choseMonthFindd: Bool? = false
    
    @IBOutlet weak var yearlabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        yearlabel.text = years[2019]
        PopoverDateVC.changeYear = 2019
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
        switch months {
        case 1:
            PopoverDateVC.passNowMonth = "01"
            PopoverDateVC.choseMonthFindd = true
            break
        case 2:
            PopoverDateVC.passNowMonth = "02"
            PopoverDateVC.choseMonthFindd = true
            break
        case 3:
            PopoverDateVC.passNowMonth = "03"
            PopoverDateVC.choseMonthFindd = true
            break
        case 4:
            PopoverDateVC.passNowMonth = "04"
            PopoverDateVC.choseMonthFindd = true
            break
        case 5:
            PopoverDateVC.passNowMonth = "05"
            PopoverDateVC.choseMonthFindd = true
            break
        case 6:
            PopoverDateVC.passNowMonth = "06"
            PopoverDateVC.choseMonthFindd = true
            break
        case 7:
            PopoverDateVC.passNowMonth = "07"
            PopoverDateVC.choseMonthFindd = true
            break
        case 8:
            PopoverDateVC.passNowMonth = "08"
            PopoverDateVC.choseMonthFindd = true
            break
        case 9:
            PopoverDateVC.passNowMonth = "09"
            PopoverDateVC.choseMonthFindd = true
            break
        case 10:
            PopoverDateVC.passNowMonth = "10"
            PopoverDateVC.choseMonthFindd = true
            break
        case 11:
            PopoverDateVC.passNowMonth = "11"
            PopoverDateVC.choseMonthFindd = true
            break
        case 12:
            PopoverDateVC.passNowMonth = "12"
            PopoverDateVC.choseMonthFindd = true
            break
        default:
            PopoverDateVC.passNowMonth = "01"
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
//
//
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

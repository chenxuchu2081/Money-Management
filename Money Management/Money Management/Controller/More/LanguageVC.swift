//
//  LanguageVC.swift
//  Money Management
//
//  Created by CHEN Xuchu on 3/10/2019.
//  Copyright © 2019 CHEN Xuchu. All rights reserved.
//

import UIKit

class LanguageVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    var language = ["English", "Chinese"]
    @IBOutlet weak var currentLanguageLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let locale = NSLocale.current.languageCode
        let pre = Locale.preferredLanguages[0]
        let localizeLanguage = NSLocalizedString("NowLanguage", comment: "")
        currentLanguageLabel.text = "\(localizeLanguage) \((pre == "en" ? "English" : "Chinese"))"
        if pre == "zh-HK"{
            language[0] = "Chinese"
            language[1] = "English"
        }
    }
    
    //MARK: - PickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }
       
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return language.count
       }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return language[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(language[row])
        if language[row] == "English"{
            //this method of change language need to restart the app
            UserDefaults.standard.set(["en"], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
            alertWithKillApp(msg: NSLocalizedString("changeToEng", comment: ""))
           
          // exit(0) shut down app
        }else{
            UserDefaults.standard.set(["zh-HK"], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
            alertWithKillApp(msg: NSLocalizedString("changeToChi", comment: ""))
           
            //exit(0)
        }
        
    }
    
    private func alertWithKillApp(msg: String){
        let alert = UIAlertController(title: NSLocalizedString("notice", comment: ""), message: msg, preferredStyle: .alert)
        let exitAppAction = UIAlertAction(title: NSLocalizedString("sure", comment: ""), style: .default, handler: {_ in exit(0)} )
        alert.addAction(exitAppAction)
        present(alert, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension String {
func localized(_ lang:String) ->String {

    let path = Bundle.main.path(forResource: lang, ofType: "lproj")
    let bundle = Bundle(path: path!)

    return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
}}

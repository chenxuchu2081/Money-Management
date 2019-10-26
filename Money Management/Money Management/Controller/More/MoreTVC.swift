//
//  MoreVC.swift
//  Money Management
//
//  Created by CHEN Xuchu on 11/10/2019.
//  Copyright © 2019 CHEN Xuchu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class MoreTVC: UITableViewController {

    @IBOutlet weak var LanguageLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var emaillabel: UILabel!

//    var name, email: String?
//    var image: UIImage?
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        _ = NSLocale.current.languageCode
        let pre = Locale.preferredLanguages[0]
        LanguageLabel.text = "Current \((pre == "en" ? "English" : "Chinese")) Language"
        
    }
    
    
   override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            self.setTitleDisplay(user)
            self.setProfileImageDisplay(user)
            self.setEmailDisplay(user)
            }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
          Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    func setTitleDisplay(_ user: User?) {
         if let name = user?.displayName {
           self.namelabel.text = name
         }
       }
       
       func setProfileImageDisplay(_ user: User?){
           if let imageUrl = user?.photoURL{
               DispatchQueue.global().async {
                   if let data = try? Data(contentsOf: imageUrl){
                       if let image = UIImage(data: data){
                           DispatchQueue.main.async {
                               self.profileImage.image = image
                           }
                       }
                   }
               }
           }
       }
       
       func setEmailDisplay(_ user: User?){
           if let email = user?.email{
               self.emaillabel.text = email
           }
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

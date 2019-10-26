//
//  AccountVC.swift
//  Money Management
//
//  Created by CHEN Xuchu on 25/9/2019.
//  Copyright © 2019 CHEN Xuchu. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseDatabase
import FirebaseAuth
import GoogleSignIn


class AccountVC: UIViewController, GIDSignInDelegate{

    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userIDLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var SynchronizeBTN: UIButton!
    @IBOutlet weak var SynchronizeLabel: UILabel!
    @IBOutlet weak var SyschronizeResultLable: UILabel!
    
    //TODO: - firebase decleration
    var ref: DatabaseReference!
    let storage = Storage.storage()

    /** @var handle
        @brief The handler for the auth state listener, to allow cancelling later.
     */
    var handle: AuthStateDidChangeListenerHandle?
    
    //TODO: - coredata decleration
       var container: NSPersistentContainer!
       let app = UIApplication.shared.delegate as! AppDelegate
       var viewContext: NSManagedObjectContext!
    
    
    
    //MARK: - viewController life cylce
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewContext = app.persistentContainer.viewContext
        ref = Database.database().reference()
       // ToggleSynchronizePart()
        // Do any additional setup after loading the view.
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
        // TODO(developer) Configure the sign-in button look/feel
        
        if Auth.auth().currentUser != nil {
          // User is signed in.
            signInButton.isEnabled = false
            
        } else {
          // No user is signed in.
          signInButton.isEnabled = true
        }
        
         
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
    
    
    
    func ToggleSynchronizePart(){
            SynchronizeBTN.animateToggleAlpha()
            SynchronizeLabel.animateToggleAlpha()
    }
    
   //MARK: - Sign in Google Account
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
     
        if let error = error {
          // ...
          return
        }
        
      guard let authentication = user.authentication else { return }
      let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
          if let error = error {
            print(error.localizedDescription)
            AlertMessages.showErrorAlert(title:"登入失敗", msg: "原因:\(error.localizedDescription)", vc: self)
            return
          }
            
              //若成功登入後，就把登入按鈕設為停用，避免重覆登入
            self.signInButton.isEnabled = false
           // self.ToggleSynchronizePart()
            if let username = user.profile.name{
                self.userIDLabel.text = username
                AlertMessages.showSuccessfulMessage(title: "登入成功", msg: "歡迎:\(username)", vc: self)
                }
        }
     
    }
//    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
//        // Perform any operations when the user disconnects from app here.
//         let firebaseAuth = Auth.auth()
//        do {
//          try firebaseAuth.signOut()
//        } catch let signOutError as NSError {
//          print ("Error signing out: %@", signOutError)
//        }
//    }
    
    @IBAction func logout(_ sender: Any) {
         do {
             //試登出
             try Auth.auth().signOut()
             GIDSignIn.sharedInstance().signOut()
             //若成功就啟用登入 button 並把訊息設成預設值
             self.signInButton.isEnabled = true
             //self.loginMessage.text = "請選擇登入方式"
         } catch  {
             print(error.localizedDescription)
         }
     }
    
    func setTitleDisplay(_ user: User?) {
      if let name = user?.displayName {
        self.userIDLabel.text = name
      } else {
        self.userIDLabel.text = "Authentication"
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
            self.userIDLabel.text = email
        }
    }
    
    //MARK: - Synchronize Cloud
    @IBAction func Synchronize(_ sender: UIButton){
        print("testing")
        SynchronizeOptions()
    }
    
   
    func SynchronizeOptions(){
        let msg = "您还未曾同步到本地过。您可以选择将本地账本上传到云（覆盖掉原来在云上的账本），或者将云上的账本同步到本地（覆盖掉原来在本地的账本)."
        let alert = UIAlertController(title: "同步", message: msg, preferredStyle: .actionSheet)
        let syncToMobile = UIAlertAction(title: "📲云上账本同步到本地", style: .default, handler: {(UIAlertAction) in
            self.syncToMobile()
        })
        let syncToCloud = UIAlertAction(title: " 🌐本地账本上传到云上", style: .default, handler: {(UIAlertAction) in
            self.syncToCloud()
        })
        let cancel = UIAlertAction(title: "❌取消", style: .cancel, handler: nil)
        alert.addAction(syncToMobile)
        alert.addAction(syncToCloud)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func syncToMobile(){
        //var msg: String?
        let user = Auth.auth().currentUser
        if let user = user{
            let userID = user.uid
            let msg = "确定将 条消费记录从云上同步到本地账本？本地账本将被覆盖。"
                           let alert = UIAlertController(title: "同步", message: msg, preferredStyle: .alert)
                           let sure = UIAlertAction(title: "✅確定", style: .default, handler: {(UIAlertAction) in
                            self.SynchronizingLoad(cloudToMobile: true, userID: userID)
                           })
                           let cancle = UIAlertAction(title: "❌取消", style: .cancel, handler: nil)
                           alert.addAction(sure)
                           alert.addAction(cancle)
                           present(alert, animated: true, completion: nil)
        }else{
            AlertMessages.showToast(msg: "please login in your account", seconds: 1, vc: self)
        }
    }
    
    func syncToCloud(){
        let MaxNumber = fetchSumCount()
        var msg: String?
        let user = Auth.auth().currentUser
        if let user = user{
            let userID = user.uid
            if MaxNumber > 0{
                msg = "确定将\(MaxNumber)条消费记录从本地上传到云上账本？云上账本将被覆盖。"
                let alert = UIAlertController(title: "同步", message: msg, preferredStyle: .alert)
                let sure = UIAlertAction(title: "✅確定", style: .default, handler: {(UIAlertAction) in
                    self.SynchronizingUpload(mobileToCloud: true, userID: userID)
                })
                let cancle = UIAlertAction(title: "❌取消", style: .cancel, handler: nil)
                alert.addAction(sure)
                alert.addAction(cancle)
                present(alert, animated: true, completion: nil)
            }else{
                msg = "您的手机里没有消费记录，不能上传。"
                let alert = UIAlertController(title: "同步", message: msg, preferredStyle: .alert)
                let cancle = UIAlertAction(title: "❌取消", style: .cancel, handler: nil)
                alert.addAction(cancle)
                present(alert, animated: true, completion: nil)
            }
        }else{
            AlertMessages.showToast(msg: "please login in your account", seconds: 1, vc: self)
        }
    }
    
    func SynchronizingUpload(mobileToCloud: Bool, userID: String){
        let msg : String?
        let MaxNumber = fetchSumCount()
       // let storageRef = storage.reference()// Create a root reference
        
                    msg = "正在上传第\(MaxNumber)条消费记录到云，请耐心等候。"
            
                
                   let anotherQueue = DispatchQueue(label: "com.appcoda.anotherQueue", qos: .utility)
                   anotherQueue.async {
                       self.delete_Storage_File(userId: userID);print("first")
                   }
                   
                   AlertMessages.showToast(msg: msg!, seconds: 1, vc: self)
                   getCoreDataForUpload(userID: userID);print("third")
                   
                   
                   SyschronizeResultLable.text = SynchronizeEnd()
        
    }
    
        
    
    func SynchronizingLoad(cloudToMobile: Bool, userID: String){
       //let msg = "正在从云上同步到本地账本，请耐心等候。"
        
        remove_CoreData_Entity()
        print("testing cloud to mobile")
        let queue = DispatchQueue.global(qos: .utility)
        queue.async(execute: {self.Load_Data_to_CoreData(userId: userID)})
        self.SyschronizeResultLable.text = SynchronizeEnd()
    }
    
  
    
    func SynchronizeEnd() -> String{
        return "同步完成✅"
    }
    
    func getCoreDataForUpload(userID: String){
        let reference = ref.child("users/\(userID)")
        
        
        do{
                        let allData = try viewContext.fetch(PopertyItem.fetchRequest())
                        for data in allData as! [PopertyItem]{
                            let name = data.name
                            let id = data.id
                            let desc = data.desc
                            let date = Helper.FormatDate(dates: data.date! as Date)
                            let price = String(data.price)
                            let type = data.type
                            
                            let image = UIImage(data: data.image! as Data)
                            print(data.name ?? "get data fail")
                            
                            //upload data to cloud
                            let randomId = UUID.init().uuidString
                            let imageRef = storage.reference(withPath: "images/\(randomId).jpg")
                           StorageService.uploadImage(image!, at: imageRef) { (downloadURL) in
                                guard let downloadURL = downloadURL else {
                                    return
                                }

                                let urlString = downloadURL.absoluteString
                                print("image url: \(urlString)")
                            
                               guard  let key = reference.childByAutoId().key else { return }
                                let post = ["name": name!,
                                            "id": id!,
                                            "desc": desc!,
                                            "date": date,
                                            "price":price,
                                             "type":type!,
                                "imageUrl":urlString] as [String: String]
                                let childUpdates = ["users/\(userID)/\(key)": post]
                                self.ref.updateChildValues(childUpdates as [AnyHashable : Any])
                            }
                            
                            print("upload successfully")
                            
                        }
                    }catch{
                        print(error)
                    }
    }
    
    func Load_Data_to_CoreData(userId: String){

            let reference = self.ref.child("users/\(userId)")
             reference.observe(.value){snapshot in
                 let isExist = snapshot.exists()
                 if isExist == true{
                     let values = snapshot.value as? NSDictionary
                     for (key, value) in values!{
                         print("Key = \(key), value = \(value)")
                          let list = value as! NSDictionary
                                print("testing...")
                                print("name: \(list["name"] as? String)")
                                
                              //insertData to core data in expends
                             let data = NSEntityDescription.insertNewObject(forEntityName: "PopertyItem", into: self.viewContext) as! PopertyItem
                             data.id = list["id"] as? String
                             data.name = list["name"] as? String
                             data.desc = list["desc"] as? String
                             data.type = list["type"] as? String
                            let price = list["price"] as? String
                                data.price = Double(price!)!
                            print("price: \(String(describing: price))")

                            let date = list["date"] as? String
                        print("date: \(String(describing: date))")
                            data.date = Helper.stringConvertDate(string: date!) as NSDate

                            if let imgUrlString = list["imageUrl"] as? String{
                                let imageUrl = URL(string: imgUrlString)
                                if let image = try? Data(contentsOf: imageUrl!){
                                    data.image = UIImage(data: image)?.jpegData(compressionQuality: 0.9) as NSData?
                                    print("save image yes")
                                    }
                            }
                            self.app.saveContext()
                            
                             }


                 }else{
                     print("no data")
                 }
             }

    }
    
    func remove_CoreData_Entity(){
            let batch = NSBatchDeleteRequest(fetchRequest: PopertyItem.fetchRequest())
            
            do {
                try app.persistentContainer.persistentStoreCoordinator.execute(batch, with: viewContext)
            } catch {
                print("fail to delete Core data object")
            }
    }
    
    func remove_Realtime_Database(userID: String){
            ref.child("users/\(userID)").removeValue()
    }
    
    func delete_Storage_File(userId: String){
        let reference = ref.child("users/\(userId)")
        reference.observeSingleEvent(of: .value, with: {(snapshot) in
            if let values = snapshot.value as? NSDictionary{
                for (key, value) in values{
                               let list = value as! NSDictionary
                               print("imageURl for delete is : \(list["imageUrl"] as! String)")
                               let imageURl = list["imageUrl"] as! String
                               
                                   // Create a reference to the file to delete
                                   let storageRef = self.storage.reference(forURL: imageURl)
                                       storageRef.delete { error in
                                         if let error = error {
                                           print(error)
                                         } else {
                                           print("File deleted successfully")
                                         }
                                       }
                               
                           }
            }
        })
        let delayQueue = DispatchQueue(label: "com.appcoda.delayqueue", qos: .utility)
        let additionalTime: DispatchTimeInterval = .seconds(1)
        delayQueue.asyncAfter(deadline: .now() + additionalTime) {
            //delete realtime database
            reference.removeValue()
        }
    }
    
    func fetchSumCount() -> Int{
        var count = 0
        do{
            let allData = try viewContext.fetch(PopertyItem.fetchRequest())
            count = allData.count
        }catch{
            //print("fetch \()sum count fail")
        }
        return count
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
    

}

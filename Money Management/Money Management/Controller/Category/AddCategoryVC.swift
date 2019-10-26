//
//  AddCategory.swift
//  Money Management
//
//  Created by CHEN Xuchu on 29/8/2019.
//  Copyright © 2019 CHEN Xuchu. All rights reserved.
//

import UIKit
import CoreData
struct CategoryPreview {
    var title:String
    var images:[String]
}

class AddCategoryVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var CollectionView: UICollectionView!
    @IBOutlet weak var nameLable: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    var categoryImage: UIImage!
    
    var isWhichSegmentName: String?
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var viewContext: NSManagedObjectContext!
    
    var category = [CategoryPreview]()
    
//                    CategoryPreview(title: "個人", images: ["Category/personal"])

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewContext = app.persistentContainer.viewContext
       
        print("testing json")
        let data = JsonRead.readJSONFromFile(fileName: "Category")
        if let jsonResult = data as? Dictionary<String, AnyObject>{
            //let entainternment = jsonResult["entertainment"] as Any
            for (key, value) in jsonResult{
                
                addCategory(title: key, key: key, value: value)
//                if key == "entertainment"{
//                    addCategory(title: "餐廳", key: key, value: value)
//                }else if key == "shopping"{
//                    addCategory(title: "購物", key: key, value: value)
//                }
                  
                print("json key: \(key)")
                print("json value: \(value)")
            }
        }
    }
    
    func addCategory(title: String, key: String, value: AnyObject){
        
            var CategoryObject = CategoryPreview(title: title, images: [])
            if let values = value as? Array<String>{
                for x in values{
                CategoryObject.images.append("Category/\(key)/\(x)")
                    print("Image url is Category/\(key)/\(x)")
                }
            category.append(CategoryObject)
        }
    }
    
    
    
    //获取分区数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return category.count
    }
    
     //获取每个分区里单元格数量
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return category[section].images.count
    }
    
    //分区的header与footer
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var reusableview:UICollectionReusableView!
        
        //分区头
        if kind == UICollectionView.elementKindSectionHeader{
            reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerView", for: indexPath)
            
            //设置头部标题
            let label = reusableview.viewWithTag(1) as! UILabel
            label.text = category[indexPath.section].title
        }
            //分区尾
        else if kind == UICollectionView.elementKindSectionFooter{
            reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footerView", for: indexPath)
        }
        return reusableview
    }
    
    //返回每个单元格视图
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //获取单元格
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath)
        
        //设置单元格中的图片
        let imageView = cell.viewWithTag(1) as? UIImageView
        imageView?.image = UIImage(named: category[indexPath.section].images[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        imageView.image = UIImage(named: category[indexPath.section].images[indexPath.item])
        categoryImage = imageView?.image
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func saveCategory(){
        let entityName = "Category_Expend"
        let name = nameLable.text
        if name != ""{
//         let isObjectExits = someEntityExists(name: name!, entityName: entityName)
//            if isObjectExits == true{
            if isWhichSegmentName == "Expend"{
                let entity = NSEntityDescription.insertNewObject(forEntityName: entityName, into: viewContext) as! Category_Expend
                entity.name = name
            if categoryImage != nil{
                entity.image = categoryImage?.jpegData(compressionQuality: 0.9) as NSData?
            }
                app.saveContext()
                AlertMessages.showToast(msg: "Expense Category Save Successfully!", seconds: 1, vc: self)
            } else if isWhichSegmentName == "Income"{
                let entity = NSEntityDescription.insertNewObject(forEntityName: "Category_Income", into: viewContext) as! Category_Income
                entity.name = name
                if categoryImage != nil{
                    entity.image = categoryImage?.jpegData(compressionQuality: 0.9) as NSData?
                }
                app.saveContext()
                AlertMessages.showToast(msg: "Income Category Save Successfully!", seconds: 1, vc: self)
            }
            //query()
//            }else{
//                alarming(text: "這個類別已經存在！")
//            }
        
        }else{
            AlertMessages.alarming(text: "空格必須填寫才能存入！", vc: self)
        }
        
        
    }
    
    //check if object exists
//    func someEntityExists(name: String, entityName: String) -> Bool{
//        let fetchRequest = NSFetchRequest<Expend>(entityName: entityName)
//        //fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
//        fetchRequest.includesSubentities = false
//        var entitiesCount = 0
//        do{
//            entitiesCount = try viewContext.count(for: fetchRequest)
//        }catch{
//             print("error executing fetch request: \(error)")
//        }
//        return entitiesCount > 0
//    }
    
    
    func alarming(text: String){
        let alert = UIAlertController(title: "注意⚠️", message: text, preferredStyle: .alert)
        let action = UIAlertAction(title: "明白了！", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated:  true, completion: nil)
    }
    
    func query(){
        do{
            let printData = try viewContext.fetch(Category_Expend.fetchRequest())
            for datas in printData as! [Category_Expend]{
                print("\(String(describing: datas.name)), \(String(describing: datas.image))")
            }
        }catch{
            print(error)
        }

    }
    
    func deleteAll(){
        do{
            let printData = try viewContext.fetch(Category_Expend.fetchRequest())
            for datas in printData as! [Category_Expend]{
                viewContext.delete(datas)
            }
            app.saveContext()
        }catch{
            print(error)
        }
    }
//    func insertData(entityName: String){
//        let entity = NSEntityDescription.insertNewObject(forEntityName: entityName, into: viewContext) as! Category_Expend
//    }
    

}

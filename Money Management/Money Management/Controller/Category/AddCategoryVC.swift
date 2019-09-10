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
    
    let category = [CategoryPreview(title: "餐廳", images: [
       "Category/Restaurant/001","Category/Restaurant/002",
       "Category/Restaurant/003","Category/Restaurant/004",
       "Category/Restaurant/005","Category/Restaurant/006",
        "Category/Restaurant/007","Category/Restaurant/008",
        "Category/Restaurant/009","Category/Restaurant/0010",
        "Category/Restaurant/0011","Category/Restaurant/0012",
       "Category/Restaurant/0013","Category/Restaurant/0014",
       "Category/Restaurant/0015","Category/Restaurant/0016",
        "Category/Restaurant/0017","Category/Restaurant/0018",
        "Category/Restaurant/0019","Category/Restaurant/0020"]),
                    CategoryPreview(title: "購物", images: [
            "Category/publicSerive/01" ,"Category/publicSerive/02","Category/publicSerive/03","Category/publicSerive/04","Category/publicSerive/05","Category/publicSerive/06","Category/publicSerive/07","Category/publicSerive/08","Category/publicSerive/09","Category/publicSerive/10"]),
                    CategoryPreview(title: "娛樂", images: [
            "Category/enterntainment/01", "Category/enterntainment/02",
            "Category/enterntainment/03", "Category/enterntainment/04",
            "Category/enterntainment/05", "Category/enterntainment/06"]),
                    CategoryPreview(title: "交通", images: [
        "Category/transportation/01", "Category/transportation/02", "Category/transportation/03","Category/transportation/04","Category/transportation/05","Category/transportation/06","Category/transportation/07","Category/transportation/08"]),
                    CategoryPreview(title: "健康", images: [
        "Category/health/01", "Category/health/02","Category/health/03"]),
                    CategoryPreview(title: "家庭", images: [
"Category/family/04","Category/family/05","Category/family/06","Category/family/07","Category/family/08","Category/family/09"]),
                    CategoryPreview(title: "電子產品", images: [
                    "Category/electronic/01", "Category/electronic/02", "Category/electronic/03"]),
                    CategoryPreview(title: "教育", images: [
                "Category/education/01", "Category/education/02", "Category/education/03","Category/education/04"]),
                    CategoryPreview(title: "個人", images: ["Category/personal"]),
                    CategoryPreview(title: "生活", images: []),
                    CategoryPreview(title: "收入", images: [])]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewContext = app.persistentContainer.viewContext
       
        
        
//        let fm = FileManager.default
//        let path = NSHomeDirectory() + "/Documents/restaurant"
//
//        do {
//            let files = try fm.contentsOfDirectory(atPath: path)
//            for file in files{
//                print(file)
//            }
//        }catch{
//            print(error)
//        }
//       print(path)
        
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
            print("Save Succussful")
            } else if isWhichSegmentName == "Income"{
                let entity = NSEntityDescription.insertNewObject(forEntityName: "Category_Income", into: viewContext) as! Category_Income
                entity.name = name
                if categoryImage != nil{
                    entity.image = categoryImage?.jpegData(compressionQuality: 0.9) as NSData?
                }
                app.saveContext()
                print("Save Succussful")
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

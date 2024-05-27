//
//  CategoryList.swift
//  MyStoryBook
//
//  Created by Kinny Padia on 26/05/24.
//

import UIKit
import CoreData

class CategoryList: UIViewController {

    var arrCatName : [String] = [String]()
    
    @IBOutlet weak var tblCategoryList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        arrCatName.removeAll()
        fetchCategories()
    }
    

    func fetchCategories() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Category")
        do {
            let categories = try managedContext.fetch(fetchRequest)
            for category in categories {
                let name = category.value(forKey: "name") as? String
                print("Name: \(name ?? "Unknown")")
                arrCatName.append(name ?? "")
                
                DispatchQueue.main.async {
                    self.tblCategoryList.reloadData()
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

}

extension CategoryList: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCatName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as! CategoryCell
        cell.lblCategoryName.text = arrCatName[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let storyListVC = storyboard.instantiateViewController(withIdentifier: "StoryList") as? StoryList {
            Global.selectedRow = arrCatName[indexPath.row]
            self.navigationController?.pushViewController(storyListVC, animated: true)
        }
    }
}

class CategoryCell: UITableViewCell{
    
    @IBOutlet weak var lblCategoryName: UILabel!
}

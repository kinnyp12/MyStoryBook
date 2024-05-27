//
//  StoryList.swift
//  MyStoryBook
//
//  Created by Kinny Padia on 26/05/24.
//

import UIKit
import CoreData

class StoryList: UIViewController {

    var arrStoryTitle : [String] = [String]()
    var arrStoryDate : [String] = [String]()
    
    @IBOutlet weak var tblStoryList: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        arrStoryTitle.removeAll()
        arrStoryDate.removeAll()
        fetchStory()
    }
    
    func fetchStory() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Story")
        do {
            let stories = try managedContext.fetch(fetchRequest)
            for story in stories {
                let c_name = story.value(forKey: "c_name") as? String
                if c_name == Global.selectedRow{
                    let title = story.value(forKey: "title") as? String
                    let date = story.value(forKey: "date") as? String
                    arrStoryTitle.append(title ?? "")
                    arrStoryDate.append(date ?? "")
                    
                    DispatchQueue.main.async {
                        self.tblStoryList.reloadData()
                    }
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

}

extension StoryList: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrStoryTitle.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoryCell", for: indexPath) as! StoryCell
        cell.lblTitle.text = arrStoryTitle[indexPath.row]
        cell.lblDate.text = "Date: " + arrStoryDate[indexPath.row]
        return cell
    }
    
}

class StoryCell: UICollectionViewCell{
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
}

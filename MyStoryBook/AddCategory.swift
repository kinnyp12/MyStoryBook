//
//  AddCategory.swift
//  MyStoryBook
//
//  Created by Kinny Padia on 26/05/24.
//

import UIKit
import CoreData

class AddCategory: UIViewController {

    @IBOutlet weak var txtCategoryName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
        
    @IBAction func btnSave(_ sender: UIButton) {
        if txtCategoryName.text != ""{
            addCategory(name: txtCategoryName.text!)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func addCategory(name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Category", in: managedContext)!
        let category = NSManagedObject(entity: entity, insertInto: managedContext)
        category.setValue(name, forKeyPath: "name")
        do {
            try managedContext.save()
            print("Saved successfully!")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}

struct Global{
    
    static var selectedRow: String?

}

@IBDesignable
class PaddedTextField: UITextField {

    // MARK: - Properties

    @IBInspectable var leftPadding: CGFloat = 0
    @IBInspectable var rightPadding: CGFloat = 0
    @IBInspectable var topPadding: CGFloat = 0
    @IBInspectable var bottomPadding: CGFloat = 0

    // MARK: - Text Rect Overrides

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: topPadding, left: leftPadding, bottom: bottomPadding, right: rightPadding))
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: topPadding, left: leftPadding, bottom: bottomPadding, right: rightPadding))
    }
}

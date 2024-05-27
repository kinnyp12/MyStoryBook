//
//  AddStoryVC.swift
//  MyStoryBook
//
//  Created by Kinny Padia on 26/05/24.
//

import UIKit
import CoreData

class AddStoryVC: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var tvStoryDetails: UITextView!
    
    let placeholder = "Enter your story here..."
    var datePicker: UIDatePicker?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        txtDate.inputView = datePicker


        tvStoryDetails.text = placeholder
        tvStoryDetails.textColor = UIColor.lightGray

    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if tvStoryDetails.text == placeholder {
            tvStoryDetails.text = nil
            tvStoryDetails.textColor = UIColor.systemIndigo
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if tvStoryDetails.text.isEmpty {
            tvStoryDetails.text = placeholder
            tvStoryDetails.textColor = UIColor.lightGray
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // If the text field is empty, set the date picker's date to today's date
        if textField.text?.isEmpty ?? true {
            datePickerValueChanged(datePicker!)
        }
    }

    // MARK: - Date Picker Action
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        txtDate.text = dateFormatter.string(from: sender.date)
        txtDate.endEditing(true)
    }


    @IBAction func btnSave(_ sender: UIButton) {
        if txtTitle.text != "" || txtDate.text != "" || tvStoryDetails.text != "" || tvStoryDetails.text != placeholder{
            addStory(title: txtTitle.text!, date: txtDate.text!, storyDetails: tvStoryDetails.text)
            self.navigationController?.popToRootViewController(animated: true)
        }
    }

    func addStory(title: String, date: String, storyDetails: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Story", in: managedContext)!
        let story = NSManagedObject(entity: entity, insertInto: managedContext)
        story.setValue(title, forKeyPath: "title")
        story.setValue(date, forKeyPath: "date")
        story.setValue(storyDetails, forKeyPath: "details")
        story.setValue(Global.selectedRow, forKeyPath: "c_name")
        do {
            try managedContext.save()
            print("Saved successfully!")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

}

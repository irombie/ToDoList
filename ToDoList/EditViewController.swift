//
//  EditViewController.swift
//  ToDoList
//
//  Created by İrem Ergun on 24/07/2017.
//  Copyright © 2017 İrem Ergun. All rights reserved.
//

import UIKit
import CoreData

class EditViewController: UIViewController {
    
    
    @IBOutlet weak var expTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var isEdit: Bool!
    
    var itemToEdit: DoItem?
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "EditToView", sender: self)
    }
 
    @IBAction func cancelClicked(_ sender: UIButton) {
        performSegue(withIdentifier: "EditToView", sender: self)
    }
    @IBAction func doneBtnClicked(_ sender: Any) {
        
        
        var item: DoItem!
        if(!isEdit){
            
            item = DoItem(context: context)
        }
        else{
            item = itemToEdit
            
        }
        
        if let name = nameTextField.text {
            item.name = name
        }
        if let explanation = expTextField.text{
            item.detail = explanation
        }
        item.date = datePicker.date as NSDate
        
        ad.saveContext()

        performSegue(withIdentifier: "EditToView", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let name = itemToEdit?.name{
            nameTextField.text = name
        }
        if let detail = itemToEdit?.detail{
            expTextField.text = detail
        }
        
        if let date = itemToEdit?.date{
            datePicker.date = date as Date
        }
        
        
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        titleLabel.text = "Edit Event"
        titleLabel.backgroundColor = UIColor.white
        self.navigationItem.titleView?.sizeToFit()
        self.navigationItem.titleView = titleLabel
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
      
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
}

//
//  DetailViewController.swift
//  ToDoList
//
//  Created by İrem Ergun on 24/07/2017.
//  Copyright © 2017 İrem Ergun. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications;

class DetailViewController: UIViewController {
    
    
   
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var explanationLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!

    
    var itemToShow: DoItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let detailControllerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        detailControllerLabel.text="Event Details"
        
        explanationLabel.text = itemToShow.detail
        nameLabel.text = itemToShow.name
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var myString = formatter.string(from: itemToShow.date! as Date)
        myString = myString.substring(to: myString.index(myString.startIndex, offsetBy:10))
        dateLabel.text = myString
        
        self.navigationItem.titleView=detailControllerLabel
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
  
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "DetailToEdit"){
            let destViewController: EditViewController = segue.destination as! EditViewController
            destViewController.isEdit = true
            destViewController.itemToEdit = itemToShow
        }
        
    }


}

//
//  CustomCell.swift
//  ToDoList
//
//  Created by İrem Ergun on 24/07/2017.
//  Copyright © 2017 İrem Ergun. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var bulletPoint: UIView!
    
    func configureCell(item: DoItem){
        
        nameLabel.text = item.name
        detailLabel.text = item.detail
        
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var myString = formatter.string(from: item.date! as Date)
        myString = myString.substring(to: myString.index(myString.startIndex, offsetBy:10))
        dateLabel.text = myString
        if(item.isDone){
            bulletPoint.backgroundColor = UIColor.red
        }
        
    }
    
    
}

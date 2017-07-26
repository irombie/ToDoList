//
//  CustomView.swift
//  ToDoList
//
//  Created by İrem Ergun on 24/07/2017.
//  Copyright © 2017 İrem Ergun. All rights reserved.
//

import UIKit


@IBDesignable

class CustomView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
            self.clipsToBounds = true
        }
    }
}

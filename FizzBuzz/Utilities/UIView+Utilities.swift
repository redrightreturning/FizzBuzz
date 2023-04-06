//
//  UIView+Utilities.swift
//  FizzBuzz
//
//  Created by Elliot Goldman on 10/11/18.
//  Copyright © 2018 Elliot Keeler. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    
    func addSubviewAndPinToSides(view : UIView){
        addSubviewAndPinToSides(view: view, offset: 0.0)
    }
    
    func addSubviewAndPinToSides(view : UIView, offset : CGFloat){
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        let leftConstraint = NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: offset)
        let rightConstraint = NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: offset)
        let topConstraint = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: offset)
        let bottomConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: offset)
        addConstraints([leftConstraint, rightConstraint, topConstraint, bottomConstraint])
    }
}

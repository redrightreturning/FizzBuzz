//
//  UILabel+Utilities.swift
//  FizzBuzz
//
//  Created by Elliot Goldman on 10/16/18.
//  Copyright © 2018 Elliot Keeler. All rights reserved.
//

import Foundation
import UIKit

extension UILabel{
    func heightForLabel(width:CGFloat) -> CGFloat{
        /*let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = false
        label.lineBreakMode = .byClipping
        label.font = self.font
        label.text = self.text
        
        label.sizeToFit()
        return label.frame.height*/
        
        self.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: CGFloat.greatestFiniteMagnitude)
        self.numberOfLines = 0
        self.adjustsFontSizeToFitWidth = false
        self.lineBreakMode = .byWordWrapping
        
        self.sizeToFit()
        return self.frame.height
    }
}

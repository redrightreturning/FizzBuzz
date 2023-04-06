//
//  UIBezierPath+Utilities.swift
//  FizzBuzz
//
//  Created by Elliot Goldman on 10/5/18.
//  Copyright © 2018 Elliot Keeler. All rights reserved.
//

import Foundation
import UIKit

extension UIBezierPath{
    func resizeToFit(rect : CGRect){
        let ratio : CGFloat
        if(self.bounds.width < self.bounds.height){
            ratio = rect.width / self.bounds.width
        }else{
            ratio = rect.height / self.bounds.height
        }
        self.apply(CGAffineTransform(scaleX: ratio, y: ratio))
    }
}

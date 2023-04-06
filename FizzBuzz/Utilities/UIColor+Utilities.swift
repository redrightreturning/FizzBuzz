//
//  UIColor+Utilities.swift
//  FizzBuzz
//
//  Created by Elliot Goldman on 9/10/18.
//  Copyright © 2018 Elliot Keeler. All rights reserved.
//

import Foundation
import UIKit

extension UIColor{
    //amount is 0.0-1.0  | 0.0 is original color, 1.0 is colorTwo
    func lerp(colorTwo : UIColor, amount : CGFloat) -> UIColor?{
        let amnt = min(max(0, amount), 1)
        
        guard let colorC = self.cgColor.components, let colorTwoC = colorTwo.cgColor.components else{
            return nil
        }
        
        guard colorC.count == 4, colorTwoC.count == 4 else{
            return nil
        }
            
        let r: CGFloat = CGFloat(colorC[0] + ((colorTwoC[0] - colorC[0]) * amnt))
        let g: CGFloat = CGFloat(colorC[1] + ((colorTwoC[1] - colorC[1]) * amnt))
        let b: CGFloat = CGFloat(colorC[2] + ((colorTwoC[2] - colorC[2]) * amnt))
        let a: CGFloat = CGFloat(colorC[3] + ((colorTwoC[3] - colorC[3]) * amnt))
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}

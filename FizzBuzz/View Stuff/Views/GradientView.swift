//
//  GradientView.swift
//  FizzBuzz
//
//  Created by Elliot Goldman on 9/10/18.
//  Copyright © 2018 Elliot Keeler. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView, FizzBuzz{
    
    let gradient = CAGradientLayer()
    //0.0 - 1.0 percent that secondaryColor should be shown
    @IBInspectable var percent : Double = 1.0{
        didSet{
            setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        gradient.frame = rect
        if let secondColor = secondaryColor.lerp(colorTwo: mainColor, amount: CGFloat(percent)){
            gradient.colors = [mainColor.cgColor, secondColor.cgColor]
        }else{
            print("Color lerp didn't work for some reason. Game will progress, but look into this")
            gradient.colors = [mainColor.cgColor, secondaryColor.cgColor]
        }
        
        gradient.startPoint = CGPoint(x: 0.5, y: 0.5)
        
       self.layer.addSublayer(gradient)
    }
}

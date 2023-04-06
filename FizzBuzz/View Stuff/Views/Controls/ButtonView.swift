//
//  ButtonView.swift
//  FizzBuzz
//
//  Created by Elliot Goldman on 9/18/18.
//  Copyright © 2018 Elliot Keeler. All rights reserved.
//

import UIKit

class ButtonView: UIButton, FizzBuzz{
    
    let ANIMATION_DURATION : CFTimeInterval = 0.5
    
    let rectLayer = CAShapeLayer()
    @IBInspectable var lineWidth : CGFloat = 2.0
    @IBInspectable var cornerRadius : CGFloat = 10.0
    var color: UIColor = UIColor.white{
        didSet{
            rectLayer.strokeColor = color.cgColor
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupButton()
    }
    
    func animateView(){
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.duration = ANIMATION_DURATION
        animation.values = [0.98, 1.02, 0.99, 1]
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        rectLayer.add(animation, forKey: "animateButton")
    }
    
    func setupButton(){
        
        tintColor = secondaryColor
        color = tertiaryColor
        titleLabel?.font = UIFont(name: "Futura", size: 17.0)
        
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        //rectLayer.bounds = bounds
        rectLayer.path = path.cgPath
        rectLayer.lineWidth = lineWidth
        rectLayer.lineCap = CAShapeLayerLineCap.round
        rectLayer.lineJoin = CAShapeLayerLineJoin.round
        rectLayer.strokeColor = color.cgColor
        rectLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(rectLayer)
        
        rectLayer.frame = bounds
    }
}

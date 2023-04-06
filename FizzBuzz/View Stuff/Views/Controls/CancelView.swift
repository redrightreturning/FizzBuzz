//
//  CancelView.swift
//  FizzBuzz
//
//  Created by Elliot Goldman on 9/18/18.
//  Copyright © 2018 Elliot Keeler. All rights reserved.
//

import UIKit

@IBDesignable
class CancelView: UIButton {
    
    let ANIMATION_DURATION : CFTimeInterval = 0.5
    @IBInspectable var lineWidth : CGFloat = 2.0
    @IBInspectable var color : UIColor = UIColor.black{
        didSet{
            layerI.strokeColor = color.cgColor
            layerII.strokeColor = color.cgColor
        }
    }
    let layerI = CAShapeLayer()
    let layerII = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    func animateView(){
        CATransaction.begin()
        
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.duration = ANIMATION_DURATION
        animation.fromValue = 0.0
        animation.toValue = (2 * CGFloat.pi)
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        layerI.add(animation, forKey: "animateCancelLayerI")
        
        let animationII = CABasicAnimation(keyPath: "transform.rotation")
        animationII.duration = ANIMATION_DURATION
        animationII.fromValue = 0.0
        animationII.toValue = (2 * CGFloat.pi)
        animationII.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        layerII.add(animation, forKey: "animateCancelLayerII")
        
        CATransaction.commit()
    }
    
    func setupButton(){
        
        let rect = bounds
        
        let pathI = UIBezierPath()
        pathI.move(to: CGPoint(x: rect.minX, y: rect.minY))
        pathI.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        
        layerI.path = pathI.cgPath
        layerI.lineWidth = lineWidth
        layerI.lineCap = CAShapeLayerLineCap.round
        layerI.lineJoin = CAShapeLayerLineJoin.round
        layerI.strokeColor = color.cgColor
        layerI.fillColor = UIColor.clear.cgColor
        layerI.frame = bounds
        self.layer.addSublayer(layerI)
        
        let pathII = UIBezierPath()
        pathII.move(to: CGPoint(x: rect.maxX, y: rect.minY))
        pathII.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        
        layerII.path = pathII.cgPath
        layerII.lineWidth = lineWidth
        layerII.lineCap = CAShapeLayerLineCap.round
        layerII.lineJoin = CAShapeLayerLineJoin.round
        layerII.strokeColor = color.cgColor
        layerII.fillColor = UIColor.clear.cgColor
        layerII.frame = bounds
        self.layer.addSublayer(layerII)
    }
}

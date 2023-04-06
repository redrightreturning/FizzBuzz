//
//  DivisionView.swift
//  FizzBuzz
//
//  Created by Elliot Goldman on 9/26/18.
//  Copyright © 2018 Elliot Keeler. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class DivisionView: UIView, FizzBuzz{
    
    let ANIMATION_DURATION : CFTimeInterval = 0.5
    
    @IBInspectable var lineWidth : CGFloat = 4.0
    @IBInspectable var color : UIColor = UIColor.white{
        didSet{
            topDotLayer.fillColor = color.cgColor
            bottomDotLayer.fillColor = color.cgColor
            lineLayer.strokeColor = color.cgColor
        }
    }
    var sideOffset : CGFloat = 16.0
    
    let bottomDotLayer = CAShapeLayer()
    let lineLayer = CAShapeLayer()
    let topDotLayer = CAShapeLayer()
    
    override func layoutSubviews() {
        setupView()
    }
    
    func animateView(){
        /*CATransaction.begin()
        
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
        
        CATransaction.commit()*/
    }
    
    func setupView(){
        color = tertiaryColor
        
        let rect = bounds
        
        let six : CGFloat = 40.0 / 6.0
        
        let topDotRect = CGRect(x: (rect.midX - (six / 2)), y: (rect.midY - (six * 2)), width: six, height: six)
        let bottomDotRect = CGRect(x: (rect.midX - (six / 2)), y: (rect.midY + six), width: six, height: six)
        
        let topDotPath = UIBezierPath(ovalIn: topDotRect)
        let bottomDotPath = UIBezierPath(ovalIn: bottomDotRect)
        topDotLayer.path = topDotPath.cgPath
        bottomDotLayer.path = bottomDotPath.cgPath
        
        [topDotLayer, bottomDotLayer].forEach{
            $0.strokeColor = UIColor.clear.cgColor
            $0.fillColor = color.cgColor
            $0.frame = bounds
            self.layer.addSublayer($0)
        }
        
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: (rect.minX + sideOffset), y: rect.midY))
        linePath.addLine(to: CGPoint(x: (rect.maxX - sideOffset), y: rect.midY))
        
        lineLayer.path = linePath.cgPath
        lineLayer.lineWidth = lineWidth
        lineLayer.lineCap = CAShapeLayerLineCap.round
        lineLayer.lineJoin = CAShapeLayerLineJoin.round
        lineLayer.strokeColor = color.cgColor
        lineLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(lineLayer)
        

    }
}

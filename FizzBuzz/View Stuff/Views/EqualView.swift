//
//  EqualView.swift
//  FizzBuzz
//
//  Created by Elliot Goldman on 10/8/18.
//  Copyright © 2018 Elliot Keeler. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class EqualView: UIView, FizzBuzz{
    
    let ANIMATION_DURATION : CFTimeInterval = 0.5
    let LINES_OFFSET : CGFloat = 6.0
    
    @IBInspectable var lineWidth : CGFloat = 4.0
    @IBInspectable var color : UIColor = UIColor.white{
        didSet{
            lineILayer.strokeColor = color.cgColor
            lineIILayer.strokeColor = color.cgColor
        }
    }
    var sideOffset : CGFloat = 16.0
    
    let lineILayer = CAShapeLayer()
    let lineIILayer = CAShapeLayer()
    
    override func layoutSubviews() {
        setupView()
    }
    
    func animateView(){
        
        lineILayer.strokeEnd = 1.0
        lineIILayer.strokeEnd = 1.0
        
        CATransaction.begin()
        
        let animation = CAKeyframeAnimation(keyPath: "strokeEnd")
        animation.duration = ANIMATION_DURATION
        animation.values = [0, 1.1, 0.9, 1]
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        lineILayer.add(animation, forKey: "animateLineILayer")
         
        let animationII = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = ANIMATION_DURATION
        animation.values = [0, 1.1, 0.9, 1]
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        lineIILayer.add(animationII, forKey: "animateLineIILayer")
         
        CATransaction.commit()
    }
    
    func setupView(){
        
        color = tertiaryColor
        
        let rect = bounds
        
        let lineIPath = UIBezierPath()
        lineIPath.move(to: CGPoint(x: (rect.minX + sideOffset), y: (rect.midY - LINES_OFFSET)))
        lineIPath.addLine(to: CGPoint(x: (rect.maxX - sideOffset), y: (rect.midY - LINES_OFFSET)))
        
        let lineIIPath = UIBezierPath()
        lineIPath.move(to: CGPoint(x: (rect.minX + sideOffset), y: (rect.midY + LINES_OFFSET)))
        lineIPath.addLine(to: CGPoint(x: (rect.maxX - sideOffset), y: (rect.midY + LINES_OFFSET)))
        
        lineILayer.path = lineIPath.cgPath
        lineIILayer.path = lineIIPath.cgPath
        
        [lineILayer, lineIILayer].forEach{
            $0.lineWidth = lineWidth
            $0.lineCap = CAShapeLayerLineCap.round
            $0.lineJoin = CAShapeLayerLineJoin.round
            $0.strokeColor = color.cgColor
            $0.fillColor = UIColor.clear.cgColor
            self.layer.addSublayer($0)
        }
    }
}

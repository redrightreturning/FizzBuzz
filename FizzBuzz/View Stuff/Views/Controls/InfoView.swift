//
//  InfoView.swift
//  FizzBuzz
//
//  Created by Elliot Goldman on 9/10/18.
//  Copyright © 2018 Elliot Keeler. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class InfoView : UIButton{
    
    let ANIMATION_DURATION : CFTimeInterval = 1.0
    let ANIMATION_KEY = "animateIDot"
    
    @IBInspectable var lineWidth : CGFloat = 2.0
    
    var color : UIColor = UIColor.white {
        didSet{
            circleLayer.strokeColor = color.cgColor
            stemLayer.strokeColor = color.cgColor
            iDot.fillColor = color.cgColor
        }
    }
    let iDot = CAShapeLayer()
    var iOffset : CGFloat{
        return bounds.height / 6.0
    }
    let circleLayer = CAShapeLayer()
    let stemLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func animateView(){
        let animation = CAKeyframeAnimation(keyPath: "position.y")
        animation.duration = ANIMATION_DURATION
        animation.values = [iDot.position.y, iDot.position.y + iOffset, iDot.position.y]
        let easeIn = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        let easeOut = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.timingFunctions = [easeIn, easeOut]
        animation.repeatCount = .infinity
        iDot.add(animation, forKey: ANIMATION_KEY)
    }
    
    func stopAnimating(){
        
        let animation = CABasicAnimation(keyPath: "position.y")
        
        let endY = iDot.position.y
        //If presentation layer doesn't exist just end the animation and return
        guard let presentation = iDot.presentation() else{
            iDot.removeAnimation(forKey: ANIMATION_KEY)
            return
        }
        let currentY = presentation.position.y
        animation.fromValue = currentY
        animation.toValue = endY
        //Figure out how long duration is based on how far it has to travel
        let distanceRatio = (currentY - endY) / iOffset
        animation.duration = (ANIMATION_DURATION * Double(distanceRatio))
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        iDot.add(animation, forKey: "iDotPlaceBackAnimation")
        iDot.removeAnimation(forKey: ANIMATION_KEY)
    }
    
    func setupView(){
        
        let rect = bounds
        
        //Outer circle
        let path = UIBezierPath(ovalIn: rect)
        
        circleLayer.path = path.cgPath
        circleLayer.lineWidth = lineWidth
        circleLayer.lineCap = CAShapeLayerLineCap.round
        circleLayer.lineJoin = CAShapeLayerLineJoin.round
        circleLayer.strokeColor = color.cgColor
        circleLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(circleLayer)
        
        //Stem of i
        //Outer circle
        let stemPath = UIBezierPath()
        stemPath.move(to: CGPoint(x: rect.midX, y: (rect.maxY - iOffset)))
        stemPath.addLine(to: CGPoint(x: rect.midX, y: rect.midY))
        
        stemLayer.path = stemPath.cgPath
        stemLayer.lineWidth = lineWidth
        stemLayer.lineCap = CAShapeLayerLineCap.round
        stemLayer.lineJoin = CAShapeLayerLineJoin.round
        stemLayer.strokeColor = color.cgColor
        stemLayer.fillColor = UIColor.clear.cgColor
        self.circleLayer.addSublayer(stemLayer)
        
        //Outer circle
        
        let circleRect = CGRect(x: (rect.midX - (iOffset / 2)), y: (rect.minY + iOffset), width: iOffset, height: iOffset)
        let dotPath = UIBezierPath(ovalIn: circleRect)
        
        iDot.path = dotPath.cgPath
        iDot.lineWidth = lineWidth
        iDot.lineCap = CAShapeLayerLineCap.round
        iDot.lineJoin = CAShapeLayerLineJoin.round
        iDot.strokeColor = UIColor.clear.cgColor
        iDot.fillColor = color.cgColor
        self.circleLayer.addSublayer(iDot)
        
    }
}

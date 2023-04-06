//
//  PoundSignView.swift
//  FizzBuzz
//
//  Created by Elliot Goldman on 9/10/18.
//  Copyright © 2018 Elliot Keeler. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class PoundSignView : UIButton{
    
    let ANIMATION_DURATION : CFTimeInterval = 0.5
    
    @IBInspectable var lineWidth : CGFloat = 2.0
    var color : UIColor = UIColor.white{
        didSet{
            [topLayer, bottomLayer, leftLayer, rightLayer].forEach(){
                $0.strokeColor = color.cgColor
            }
        }
    }
    let topLayer = CAShapeLayer()
    let bottomLayer = CAShapeLayer()
    let leftLayer = CAShapeLayer()
    let rightLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func animateView(){
        
        let valI : CGFloat = 0.8
        let valII : CGFloat = 0.4
        let valIII : CGFloat = 0.2
        
        CATransaction.begin()
        
        let leftAnimation = CAKeyframeAnimation(keyPath: "position.x")
        leftAnimation.duration = ANIMATION_DURATION
        let leftX = leftLayer.position.x
        leftAnimation.values = [leftX + valI, leftX - valII, leftX + valIII, leftX]
        leftAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        leftLayer.add(leftAnimation, forKey: "animateLeftLayer")
        
        let rightAnimation = CAKeyframeAnimation(keyPath: "position.x")
        rightAnimation.duration = ANIMATION_DURATION
        let rightX = rightLayer.position.x
        rightAnimation.values = [rightX - valI, rightX + valII, rightX - valIII, rightX]
        rightAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        rightLayer.add(rightAnimation, forKey: "animateRightLayer")
        
        let topAnimation = CAKeyframeAnimation(keyPath: "position.y")
        topAnimation.duration = ANIMATION_DURATION
        let topY = topLayer.position.y
        topAnimation.values = [topY + valI, topY - valII, topY + valIII, topY]
        topAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        topLayer.add(topAnimation, forKey: "animateTopLayer")
        
        let bottomAnimation = CAKeyframeAnimation(keyPath: "position.y")
        bottomAnimation.duration = ANIMATION_DURATION
        let bottomY = bottomLayer.position.y
        bottomAnimation.values = [bottomY - valI, bottomY + valII, bottomY - valIII, bottomY]
        bottomAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        bottomLayer.add(bottomAnimation, forKey: "animateBottomLayer")
        
        CATransaction.commit()
    }
    
    func setupView(){
        let rect = bounds
        
        let third = rect.width / 3.5
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: (rect.minX + third), y: rect.minY))
        path.addLine(to: CGPoint(x: (rect.minX + third), y: rect.maxY))
        leftLayer.path = path.cgPath
        
        let pathII = UIBezierPath()
        pathII.move(to: CGPoint(x: (rect.maxX - third), y: rect.minY))
        pathII.addLine(to: CGPoint(x: (rect.maxX - third), y: rect.maxY))
        rightLayer.path = pathII.cgPath
        
        let thirdH = rect.height / 3.5
        
        let pathIII = UIBezierPath()
        pathIII.move(to: CGPoint(x: rect.minX, y: (rect.minY + thirdH)))
        pathIII.addLine(to: CGPoint(x: rect.maxX, y: (rect.minY + thirdH)))
        topLayer.path = pathIII.cgPath
        
        let pathIV = UIBezierPath()
        pathIV.move(to: CGPoint(x: rect.minX, y: (rect.maxY - thirdH)))
        pathIV.addLine(to: CGPoint(x: rect.maxX, y: (rect.maxY - thirdH)))
        bottomLayer.path = pathIV.cgPath
        
        [topLayer, bottomLayer, leftLayer, rightLayer].forEach(){
            $0.lineWidth = lineWidth
            $0.lineCap = CAShapeLayerLineCap.round
            $0.lineJoin = CAShapeLayerLineJoin.round
            $0.strokeColor = color.cgColor
            $0.fillColor = UIColor.clear.cgColor
            self.layer.addSublayer($0)
        }
    }
}

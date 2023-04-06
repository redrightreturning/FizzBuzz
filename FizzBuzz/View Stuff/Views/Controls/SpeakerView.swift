//
//  SpeakerView.swift
//  FizzBuzz
//
//  Created by Elliot Goldman on 9/10/18.
//  Copyright © 2018 Elliot Keeler. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class SpeakerView : UIButton, FizzBuzz{
    
    let ANIMATION_DURATION : CFTimeInterval = 0.5
    
    @IBInspectable var lineWidth : CGFloat = 2.0
    var color : UIColor = UIColor.white
    var on : Bool = false{
        didSet{
            setNeedsDisplay()
            if(on){
                animateOn()
            }else{
                animateOff()
            }
        }
    }
    
    lazy var onColor : UIColor = {
        return tertiaryColor
    }()
    
    lazy var offColor : UIColor = {
        return secondaryColor
    }()
    
    var lineLayers = [CAShapeLayer]()
    var offLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func animateOn(){
        offLayer.transform = CATransform3DMakeScale(0.0, 0.0, 1.0)
        
        let animation = CAKeyframeAnimation(keyPath: "strokeEnd")
        animation.duration = ANIMATION_DURATION
        
        animation.values = [0, 1.1, 0.9, 1]
        
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        lineLayers.forEach{
            $0.strokeStart = 0.0
            $0.strokeEnd = 1.0
        }
        
        lineLayers.forEach{
            $0.add(animation, forKey: "animateSpeakerOn")
        }
    }
    
    func animateOff(){
        //Animate lineLayers out
        let lineAnimation = CABasicAnimation(keyPath: "strokeStart")
        lineAnimation.duration = 0.2
        
        lineAnimation.fromValue = 0.0
        lineAnimation.toValue = 1.0
        
        lineAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        lineLayers.forEach{
            $0.strokeStart = 1.0
        }
        
        CATransaction.setCompletionBlock{[weak self] in
                self?.lineLayers.forEach{
                    //Hide, fix the start and end for next animation, put back
                    CATransaction.setDisableActions(true)
                    $0.strokeStart = 0.0
                    $0.strokeEnd = 0.0
                    CATransaction.commit()
                }
        }
        lineLayers.forEach{
            $0.add(lineAnimation, forKey: "animateSpeakerOn")
        }
        CATransaction.commit()
        
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.duration = ANIMATION_DURATION
        
        animation.values = [0, 1.1, 0.9, 1]
        
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        offLayer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0)
        
        offLayer.add(animation, forKey: "animateSpeakerOff")
        
    }
    
    func setupView(){
        
        let rect = bounds
        
        let speakerWidth = (rect.width / 3.0)
        let lineOffset = speakerWidth * (2/3)
        
        let path = UIBezierPath()
        let third = rect.height / 2.5
        let speakerYOffset = rect.height / 6
        path.move(to: CGPoint(x: (rect.minX + speakerWidth), y: (rect.minY + speakerYOffset)))
        path.addLine(to: CGPoint(x: rect.minX, y: (rect.minY + third)))
        path.addLine(to: CGPoint(x: rect.minX, y: (rect.maxY - third)))
        path.addLine(to: CGPoint(x: (rect.minX + speakerWidth), y: (rect.maxY - speakerYOffset)))
        
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.lineWidth = lineWidth
        layer.lineCap = CAShapeLayerLineCap.round
        layer.lineJoin = CAShapeLayerLineJoin.round
        layer.strokeColor = color.cgColor
        layer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(layer)
        
        let pathII = UIBezierPath()
        pathII.move(to: CGPoint(x: (rect.minX + speakerWidth), y: (rect.minY + speakerYOffset)))
        pathII.addQuadCurve(to: CGPoint(x: (rect.minX + speakerWidth), y: (rect.maxY - speakerYOffset)), controlPoint: CGPoint(x: (rect.maxX - (rect.width / 2.0)), y: rect.midY))
        
        let layerII = CAShapeLayer()
        layerII.path = pathII.cgPath
        layerII.lineWidth = lineWidth
        layerII.lineCap = CAShapeLayerLineCap.round
        layerII.lineJoin = CAShapeLayerLineJoin.round
        layerII.strokeColor = color.cgColor
        layerII.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(layerII)
        
        //On lines
        let linePathI = UIBezierPath()
        linePathI.move(to: CGPoint(x:(rect.minX + speakerWidth + lineOffset) , y: rect.midY))
        linePathI.addLine(to: CGPoint(x:(rect.maxX - lineOffset), y: rect.midY))
        
        let lineLayerI = CAShapeLayer()
        lineLayerI.path = linePathI.cgPath
        lineLayerI.lineWidth = lineWidth
        lineLayerI.lineCap = CAShapeLayerLineCap.round
        lineLayerI.lineJoin = CAShapeLayerLineJoin.round
        lineLayerI.strokeColor = color.cgColor
        lineLayerI.fillColor = UIColor.clear.cgColor
        lineLayerI.strokeEnd = 0.0
        self.layer.addSublayer(lineLayerI)
        lineLayers.append(lineLayerI)
        
        let linePathII = UIBezierPath()
        let quarter = rect.height / 4.0
        linePathII.move(to: CGPoint(x:(rect.minX + speakerWidth + lineOffset) , y: (rect.midY - quarter)))
        linePathII.addLine(to: CGPoint(x:(rect.maxX - lineOffset), y: rect.minY))
        
        let lineLayerII = CAShapeLayer()
        lineLayerII.path = linePathII.cgPath
        lineLayerII.lineWidth = lineWidth
        lineLayerII.lineCap = CAShapeLayerLineCap.round
        lineLayerII.lineJoin = CAShapeLayerLineJoin.round
        lineLayerII.strokeColor = onColor.cgColor
        lineLayerII.fillColor = UIColor.clear.cgColor
        lineLayerII.strokeEnd = 0.0
        self.layer.addSublayer(lineLayerII)
        lineLayers.append(lineLayerII)
        
        let linePathIII = UIBezierPath()
        linePathIII.move(to: CGPoint(x:(rect.minX + speakerWidth + lineOffset) , y: (rect.midY + quarter)))
        linePathIII.addLine(to: CGPoint(x:(rect.maxX - lineOffset), y: rect.maxY))
        
        let lineLayerIII = CAShapeLayer()
        lineLayerIII.path = linePathIII.cgPath
        lineLayerIII.lineWidth = lineWidth
        lineLayerIII.lineCap = CAShapeLayerLineCap.round
        lineLayerIII.lineJoin = CAShapeLayerLineJoin.round
        lineLayerIII.strokeColor = onColor.cgColor
        lineLayerIII.fillColor = UIColor.clear.cgColor
        lineLayerIII.strokeEnd = 0.0
        self.layer.addSublayer(lineLayerIII)
        lineLayers.append(lineLayerIII)
        
        //off circle
        let widthHeight = rect.width - speakerWidth - (2 * lineOffset)
        let circleX = (rect.minX + speakerWidth + lineOffset)
        let circleY = (rect.midY - (widthHeight / 2))
        let circleRect = CGRect(x: circleX, y: circleY, width: widthHeight, height: widthHeight)
        let circlePath = UIBezierPath(ovalIn: circleRect)
        
        offLayer.path = circlePath.cgPath
        offLayer.lineWidth = lineWidth
        offLayer.lineCap = CAShapeLayerLineCap.round
        offLayer.lineJoin = CAShapeLayerLineJoin.round
        offLayer.strokeColor = UIColor.clear.cgColor
        offLayer.fillColor = offColor.cgColor
        self.layer.addSublayer(offLayer)
        
        offLayer.frame = rect
    }
}

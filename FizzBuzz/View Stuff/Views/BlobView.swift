//
//  BlobView.swift
//  FizzBuzz
//
//  Created by Elliot Goldman on 9/11/18.
//  Copyright © 2018 Elliot Keeler. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class BlobView : UIView, FizzBuzz{
    
    let ANIMATION_DURATION : CFTimeInterval = 0.5
    let RECT_OFFSET : CGFloat = 5.0
    
    let blobLayer = CAShapeLayer()
    @IBInspectable var lineWidth : CGFloat = 2.0
    @IBInspectable var color : UIColor = UIColor.white{
        didSet{
            blobLayer.fillColor = color.cgColor
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupView()
    }
    
    func setupView(){
        color = tertiaryColor
        
        blobLayer.path = blobPath().cgPath
        blobLayer.lineWidth = lineWidth
        blobLayer.lineCap = CAShapeLayerLineCap.round
        blobLayer.lineJoin = CAShapeLayerLineJoin.round
        blobLayer.strokeColor = UIColor.clear.cgColor
        blobLayer.fillColor = color.cgColor
        self.layer.addSublayer(blobLayer)
    }
    
    func blobPath()->UIBezierPath{
        let rect = bounds
        //Returns the coordinates of circle
        //positive is whether circle(half) is up or down (true is down)
        func circle(x : CGFloat, radius : CGFloat, positive : Bool)->CGFloat{
            //(h,i) is the center of the circle
            //(x−h)2+(y−i)2=r2
            let h = radius
            var y = sqrt( abs(pow(radius, 2) - pow((x - h), 2) ))
            if(!positive){
                y = (y * -1)
            }
            return y
        }
        
        //To be honest this is random and I don't get it...idk
        let offset : CGFloat = rect.width / 4
        
        let randomLimit : CGFloat = rect.width / 10
        var r = [CGFloat]()
        for _ in 0...15{
            r.append(CGFloat.random(in: -randomLimit...randomLimit))
        }
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        //Quad II
        var point = CGPoint(x: rect.midX, y: rect.minY)
        var controlPointI = CGPoint(x: (rect.minX + r[0]), y: (rect.midY - offset - r[1]))
        var controlPointII = CGPoint(x: (rect.midX - offset + r[2]), y: (rect.minY + r[3]))
        path.addCurve(to: point, controlPoint1: controlPointI, controlPoint2: controlPointII)
        //Quad I
        point = CGPoint(x: rect.maxX, y: rect.midY)
        controlPointI = CGPoint(x: (rect.midX + offset + r[4]), y: (rect.minY + r[5]))
        controlPointII = CGPoint(x: (rect.maxX + r[6]), y: (rect.midY - offset + r[7]))
        path.addCurve(to: point, controlPoint1: controlPointI, controlPoint2: controlPointII)
        //Quad III
        point = CGPoint(x: rect.midX, y: rect.maxY)
        controlPointI = CGPoint(x: (rect.maxX + r[8]), y: (rect.midY + offset + r[9]))
        controlPointII = CGPoint(x: (rect.midX + offset + r[10]), y: (rect.maxY + r[11]))
        path.addCurve(to: point, controlPoint1: controlPointI, controlPoint2: controlPointII)
        //Quad IV
        point = CGPoint(x: rect.minX, y: rect.midY)
        controlPointI = CGPoint(x: (rect.midX - offset + r[12]), y: (rect.maxY + r[13]))
        controlPointII = CGPoint(x: (rect.minX + r[14]), y: (rect.midY + offset + r[15]))
        path.addCurve(to: point, controlPoint1: controlPointI, controlPoint2: controlPointII)
        
        return path
    }
    
    func changeBlob(){
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = ANIMATION_DURATION
        
        let newPath = blobPath()
        animation.fromValue = blobLayer.path
        animation.toValue = newPath.cgPath
        
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        blobLayer.path = newPath.cgPath
        
        blobLayer.add(animation, forKey: "newBlobPath")
    }
}

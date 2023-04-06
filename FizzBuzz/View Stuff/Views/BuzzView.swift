//
//  BuzzView.swift
//  FizzBuzz
//
//  Created by Elliot Goldman on 10/5/18.
//  Copyright © 2018 Elliot Keeler. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class BuzzView : UIView, FizzBuzz, AnimateStroke{
    
    let mainLayer = CAShapeLayer()
    let secondaryLayer = CAShapeLayer()
    @IBInspectable var lineWidth : CGFloat = 2.0
    @IBInspectable var color : UIColor = UIColor.white{
        didSet{
            mainLayer.strokeColor = color.cgColor
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupView()
    }
    
    func setupView(){
         
        let path = UIBezierPath()
        //B
        path.move(to: CGPoint(x: 0.0, y: 0.0))
        path.addLine(to: CGPoint(x: (0.0), y: (126.15) ))
        path.addCurve(to: CGPoint(x: 37.87, y: 111.29), controlPoint1: CGPoint(x: 0.0, y: 126.15), controlPoint2: CGPoint(x: 22.17, y: 130.62))
        path.addCurve(to: CGPoint(x: 28.29, y: 42.0), controlPoint1: CGPoint(x: 51.239999999999995, y: 94.83000000000001), controlPoint2: CGPoint(x: 64.69999999999999, y: 43.400000000000006))
        path.addCurve(to: CGPoint(x: 50.03, y: 17.97), controlPoint1: CGPoint(x: 28.29, y: 42.0), controlPoint2: CGPoint(x: 50.5, y: 45.35))
        path.addCurve(to: CGPoint(x: 39.010000000000005, y: 0.259999999999998), controlPoint1: CGPoint(x: 49.89, y: 9.6), controlPoint2: CGPoint(x: 48.93, y: -0.10999999999999943))
        path.addLine(to: CGPoint(x: 0.0, y: 0.0))
        path.close()
        
        //U
        path.move(to: CGPoint(x: 59.14, y: 0.0))
        path.addLine(to: CGPoint(x: (59.14), y: (114.23) ))
        path.addCurve(to: CGPoint(x: 69.14, y: 126.15), controlPoint1: CGPoint(x: 59.14, y: 114.23), controlPoint2: CGPoint(x: 59.43, y: 126.15))
        path.addCurve(to: CGPoint(x: 79.14, y: 114.23), controlPoint1: CGPoint(x: 78.85, y: 126.15), controlPoint2: CGPoint(x: 79.14, y: 114.23))
        path.addLine(to: CGPoint(x: 79.14, y: 0.0))
        
        //Z
        path.move(to: CGPoint(x: 95.43, y: -0.12))
        path.addLine(to: CGPoint(x: 113.75, y: -0.12))
        path.addLine(to: CGPoint(x: 88.5, y: 123.81))
        path.addLine(to: CGPoint(x: 106.79, y: 123.81))
        
        //Z
        path.move(to: CGPoint(x: 124.56, y: 0.0))
        path.addLine(to: CGPoint(x: 142.89, y: 0))
        path.addLine(to: CGPoint(x: 117.63, y: 123.93))
        path.addLine(to: CGPoint(x: 135.93, y: 123.93))
        
        
        path.resizeToFit(rect: bounds)
        
        [mainLayer].forEach{//[mainLayer, secondaryLayer].forEach{
            $0.path = path.cgPath
            $0.lineWidth = lineWidth
            $0.lineCap = CAShapeLayerLineCap.round
            $0.lineJoin = CAShapeLayerLineJoin.round
            $0.strokeColor = color.cgColor
            $0.fillColor = UIColor.clear.cgColor
            $0.frame = bounds
            $0.strokeEnd = 0.0
            self.layer.addSublayer($0)
        }
    }
}

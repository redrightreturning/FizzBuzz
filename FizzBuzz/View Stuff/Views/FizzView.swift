//
//  FizzView.swift
//  FizzBuzz
//
//  Created by Elliot Goldman on 10/5/18.
//  Copyright © 2018 Elliot Keeler. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class FizzView : UIView, FizzBuzz, AnimateStroke{
    
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
        //F
        path.move(to: CGPoint(x: 67.66, y: 0.0))
        path.addLine(to: CGPoint(x: 0.0, y: 0.0))
        path.addLine(to: CGPoint(x: 0.0, y: 125.31))
        
        path.move(to: CGPoint(x: 0.0, y: 25.29))
        path.addLine(to: CGPoint(x: 53.81, y: 25.29))
        
        //I
        path.move(to: CGPoint(x: 38.9, y: 44.06))
        path.addLine(to: CGPoint(x: 38.9, y: 125.31))
        
        //Z
        path.move(to: CGPoint(x: 78.97, y: 0.0))
        path.addLine(to: CGPoint(x: 104.36, y: 0.0))
        path.addLine(to: CGPoint(x: 72.47, y: 125.31))
        path.addLine(to: CGPoint(x: 94.58, y: 125.31))
        
        //Z
        path.move(to: CGPoint(x: 116.29, y: 0.0))
        path.addLine(to: CGPoint(x: 141.68, y: 0.0))
        path.addLine(to: CGPoint(x: 109.79, y: 125.31))
        path.addLine(to: CGPoint(x: 131.9, y: 125.31))
        
        path.resizeToFit(rect: bounds)
        
        [mainLayer].forEach{//[secondaryLayer, mainLayer].forEach{
            $0.path = path.cgPath
            $0.lineWidth = lineWidth
            $0.lineCap = CAShapeLayerLineCap.round
            $0.lineJoin = CAShapeLayerLineJoin.round
            $0.fillColor = UIColor.clear.cgColor
            $0.frame = bounds
            $0.strokeEnd = 0.0
            self.layer.addSublayer($0)
        }
        mainLayer.strokeColor = color.cgColor
        secondaryLayer.strokeColor = secondaryColor.cgColor
    }
}

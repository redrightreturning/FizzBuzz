//
//  CrownView.swift
//  FizzBuzz
//
//  Created by Elliot Goldman on 9/10/18.
//  Copyright © 2018 Elliot Keeler. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CrownView : UIView{
    
    @IBInspectable var lineWidth : CGFloat = 2.0
    @IBInspectable var color : UIColor = UIColor.white{
        didSet{
            crownLayer.strokeColor = color.cgColor
        }
    }
    let crownLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView(){
        let rect = bounds
        
        let path = UIBezierPath()
        let fourth = rect.width / 4
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX + fourth, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX + fourth, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        
        crownLayer.path = path.cgPath
        crownLayer.lineWidth = lineWidth
        crownLayer.lineCap = CAShapeLayerLineCap.round
        crownLayer.lineJoin = CAShapeLayerLineJoin.round
        crownLayer.strokeColor = color.cgColor
        crownLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(crownLayer)
    }
}

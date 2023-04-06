//
//  AnimateStroke.swift
//  FizzBuzz
//
//  Created by Elliot Goldman on 10/8/18.
//  Copyright © 2018 Elliot Keeler. All rights reserved.
//

import Foundation
import UIKit

protocol AnimateStroke{
    var mainLayer : CAShapeLayer{get}
    var secondaryLayer : CAShapeLayer{get}
}

extension AnimateStroke where Self : UIView{
    
    var ANIMATION_DURATION_I : CFTimeInterval{
        return 0.5
    }
    var ANIMATION_DURATION_II : CFTimeInterval{
        return 0.8
    }
    var ANIMATION_OFFSET : CFTimeInterval{
        return 0.2
    }
    var SECOND_ANIMATION_OFFSET : CFTimeInterval{
        return 0.1
    }
    
    func animateView(){
        
        mainLayer.strokeEnd = 1.0
        mainLayer.strokeStart = 0.0
        
        secondaryLayer.strokeEnd = 1.0
        secondaryLayer.strokeStart = 0.0
        
        CATransaction.begin()
        
        let endAnimation = CABasicAnimation(keyPath: "strokeEnd")
        endAnimation.duration = ANIMATION_DURATION_I
        endAnimation.fromValue = 0.0
        endAnimation.toValue = 1.0
        endAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        mainLayer.add(endAnimation, forKey: "animateFizzEnd")
        
        /*let secondEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        secondEndAnimation.duration = ANIMATION_DURATION_I
        secondEndAnimation.fromValue = 0.0
        secondEndAnimation.toValue = 1.0
        secondEndAnimation.beginTime = CACurrentMediaTime() + SECOND_ANIMATION_OFFSET
        secondEndAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        secondaryLayer.add(secondEndAnimation, forKey: "animateSecondFizzEnd")*/
        
        CATransaction.setCompletionBlock{[unowned self] in
            CATransaction.begin()
            //Hide, fix the start and end for next animation, put back
            CATransaction.setDisableActions(true)
            self.mainLayer.strokeEnd = 0.0
            self.secondaryLayer.strokeEnd = 0.0
            CATransaction.commit()
        }
        
        let startAnimation = CABasicAnimation(keyPath: "strokeStart")
        startAnimation.duration = ANIMATION_DURATION_II
        startAnimation.fromValue = 0.0
        startAnimation.toValue = 1.0
        startAnimation.beginTime = CACurrentMediaTime() + ANIMATION_OFFSET
        startAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        mainLayer.add(startAnimation, forKey: "animateFizzStart")
        
        /*let secondStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        secondStartAnimation.duration = ANIMATION_DURATION_II
        secondStartAnimation.fromValue = 0.0
        secondStartAnimation.toValue = 1.0
        secondStartAnimation.beginTime = CACurrentMediaTime() + ANIMATION_OFFSET + SECOND_ANIMATION_OFFSET
        secondStartAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        secondaryLayer.add(secondStartAnimation, forKey: "animateFizzStart")*/
        
        CATransaction.commit()
    }
}

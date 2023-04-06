//
//  FizzBuzzButtonsViewOO.swift
//  FizzBuzz
//
//  Created by Elliot Goldman on 10/3/18.
//  Copyright © 2018 Elliot Keeler. All rights reserved.
//

import Foundation
import UIKit

enum FizzBuzzButtonsViewButtons{
    case fizz
    case buzz
    case fizzBuzz
}

protocol FizzBuzzButtonsViewDelegate{
    func buttonTapped(button : FizzBuzzButtonsViewButtons)
}

@IBDesignable
class FizzBuzzButtonsView : UIImageView, FizzBuzz{
    
    let ANIMATION_DURATION : CFTimeInterval = 0.5
    let BUTTON_SPACE : CGFloat = 50.0
    
    var delegate : FizzBuzzButtonsViewDelegate?
    var buzzView = FizzBuzzButton()
    var fizzView = FizzBuzzButton()
    var fizzTapped = false
    var buzzTapped = false
    var activated = true
    
    var number1 = 3 {
        didSet{
            fizzView.number = number1
        }
    }
    var number2 = 5 {
        didSet{
            buzzView.number = number2
        }
    }
    
    @IBInspectable var lineWidth : CGFloat = 3.0
    @IBInspectable var color : UIColor = UIColor.white{
        didSet{
            fizzView.color = color
            buzzView.color = color
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView(){
 
        
        fizzView.addTarget(self, action: #selector(self.fizzTappedDown(sender:)), for: .touchDown)
        fizzView.addTarget(self, action: #selector(self.fizzTappedUp(sender:)), for: .touchUpInside)
        buzzView.addTarget(self, action: #selector(self.buzzTappedDown(sender:)), for: .touchDown)
        buzzView.addTarget(self, action: #selector(self.buzzTappedUp(sender:)), for: .touchUpInside)
        
        fizzView.color = color
        buzzView.color = color
        
        //fizzView
        fizzView.translatesAutoresizingMaskIntoConstraints = false
        fizzView.isFizz = true
        self.addSubview(fizzView)
        let leftFizzConstraint = NSLayoutConstraint(item: fizzView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0)
        let topFizzConstraint = NSLayoutConstraint(item: fizzView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
        let bottomFizzConstraint = NSLayoutConstraint(item: fizzView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        let rightFizzConstraint = NSLayoutConstraint(item: fizzView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: ((BUTTON_SPACE / 2) * -1))
        self.addConstraints([leftFizzConstraint, topFizzConstraint, bottomFizzConstraint, rightFizzConstraint])
        
        //buzzView
        buzzView.translatesAutoresizingMaskIntoConstraints = false
        buzzView.isFizz = false
        self.addSubview(buzzView)
        let topBuzzConstraint = NSLayoutConstraint(item: buzzView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
        let bottomBuzzConstraint = NSLayoutConstraint(item: buzzView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        let rightBuzzConstraint = NSLayoutConstraint(item: buzzView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0)
        let leftBuzzConstraint = NSLayoutConstraint(item: buzzView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: (BUTTON_SPACE / 2))
        self.addConstraints([topBuzzConstraint, bottomBuzzConstraint, rightBuzzConstraint, leftBuzzConstraint])
 
    }
    
    @objc func fizzTappedDown(sender : ButtonView){
        fizzTapped = true
        //Check if both are pressed
        if(fizzTapped && buzzTapped && activated){
            delegate?.buttonTapped(button: .fizzBuzz)
            //Make both false so they don't double trigger
            fizzTapped = false
            buzzTapped = false
        }
    }
    
    @objc func fizzTappedUp(sender : ButtonView){
        if(activated){
            viewTapped()
            fizzView.animateFizzOrBuzz()
        }
        fizzTapped = false
    }
    
    @objc func buzzTappedDown(sender : ButtonView){
        buzzTapped = true
        //Check if both are pressed
        if(fizzTapped && buzzTapped && activated){
            delegate?.buttonTapped(button: .fizzBuzz)
            //Make both false so they don't double trigger
            fizzTapped = false
            buzzTapped = false
        }
    }
    
    @objc func buzzTappedUp(sender : ButtonView){
        if(activated){
            viewTapped()
            buzzView.animateFizzOrBuzz()
        }
        buzzTapped = false
    }
    
    
    func viewTapped(){
        //Return if both are down because it was dealt with in buttonDown
        if(fizzTapped && buzzTapped){
            return
        }else if(fizzTapped){
            delegate?.buttonTapped(button: .fizz)
        }else if(buzzTapped){
            delegate?.buttonTapped(button: .buzz)
        }
    }
}

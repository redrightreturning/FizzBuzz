//
//  PopoverView.swift
//  FizzBuzz
//
//  Created by Elliot Goldman on 10/11/18.
//  Copyright © 2018 Elliot Keeler. All rights reserved.
//

import Foundation
import UIKit

protocol PopoverViewDelegate{
    func buttonPressed()
}

@IBDesignable
class PopoverView : UIView, FizzBuzz, DeviceFeedback{
    
    let CHANGE_ANIMATION_DURATION : CFTimeInterval = 0.5
    let BUTTON_HEIGHT : CGFloat = 30.0
    let EQUATION_STACK_HEIGHT : CGFloat = 34.0
    let Y_OFFSET : CGFloat = 10.0
    let STACK_OFFSET : CGFloat = 20.0
    let STACK_SPACING : CGFloat = 10.0
    let WIDTH : CGFloat = 210.0
    
    @IBInspectable var color : UIColor = UIColor.white{
        didSet{
            mainLayer.fillColor = color.cgColor
        }
    }
    @IBInspectable var cornerRadius : CGFloat = 10.0
    
    var delegate : PopoverViewDelegate?
    private var label = UILabel()
    private var nextButton = ButtonView()
    private let mainLayer = CAShapeLayer()
    private let stackView = UIStackView()
    var stackViewHeightConstraint = NSLayoutConstraint()
    let equationViewStack = EquationViewStack()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("Popover view can't be initiated from Storyboard!!!")
    }
    
    func setupView(){
        //Start off as transparent
        self.alpha = 0.0
        
        //View
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.shadowRadius = cornerRadius
        
        //Stackview
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = STACK_SPACING
        addSubviewAndPinToSides(view: stackView, offset : STACK_OFFSET)
        
        //Label
        label.text = "This is a test of the emergency broadcast system. Who knew that things could be this way?"
        label.textAlignment = .center
        label.font = UIFont(name: "Futura", size: 15.0)
        label.lineBreakMode = .byClipping
        label.minimumScaleFactor = 0.25
        label.numberOfLines = 0
        stackView.addArrangedSubview(label)
        
        //EquationView Stack
        equationViewStack.equationViewI.equalView.sideOffset = HowToViewController.EQUATION_SIDE_OFFSET
        equationViewStack.equationViewI.divisionView.sideOffset = HowToViewController.EQUATION_SIDE_OFFSET
        equationViewStack.equationViewII.equalView.sideOffset = HowToViewController.EQUATION_SIDE_OFFSET
        equationViewStack.equationViewII.divisionView.sideOffset = HowToViewController.EQUATION_SIDE_OFFSET
        
        equationViewStack.equationViewI.equalView.lineWidth = HowToViewController.EQUATION_LINE_WIDTH
        equationViewStack.equationViewI.divisionView.lineWidth = HowToViewController.EQUATION_LINE_WIDTH
        equationViewStack.equationViewII.equalView.lineWidth = HowToViewController.EQUATION_LINE_WIDTH
        equationViewStack.equationViewII.divisionView.lineWidth = HowToViewController.EQUATION_LINE_WIDTH
        
        equationViewStack.equationViewI.color = .black
        equationViewStack.equationViewII.color = .black
        stackViewHeightConstraint = NSLayoutConstraint(item: equationViewStack, attribute: .height, relatedBy: .equal, toItem:nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0.0)
        equationViewStack.addConstraint(stackViewHeightConstraint)
        stackView.addArrangedSubview(equationViewStack)
        equationViewStack.isHidden = true
        
        //Button
        nextButton.color = tertiaryColor
        nextButton.setTitle("Next", for: .normal)
        nextButton.setTitleColor(secondaryColor, for: .normal)
        nextButton.cornerRadius = 8
        let buttonHeight = NSLayoutConstraint(item: nextButton, attribute: .height, relatedBy: .equal, toItem:nil, attribute: .notAnAttribute, multiplier: 1.0, constant: BUTTON_HEIGHT)
        nextButton.addConstraint(buttonHeight)
        stackView.addArrangedSubview(nextButton)
        nextButton.addTarget(self, action: #selector(self.buttonTapped(sender:)), for: .touchUpInside)
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        
        mainLayer.path = path.cgPath
        mainLayer.lineWidth = 0.0
        mainLayer.fillColor = color.cgColor
        self.layer.addSublayer(mainLayer)
        
        bringSubviewToFront(stackView)
    }
    
    @objc func buttonTapped(sender: UIButton){
        nextButton.animateView()
        delegate?.buttonPressed()
    }
    
    func configurePopoverView(pointOfInterest : CGPoint, above : Bool, text : String, showButton : Bool, equationViewNumbers : (numI : Int, numII_I : Int, numII_II : Int?)?){
        
        label.text = text
        
        if let equationViewNumbers = equationViewNumbers{
            self.equationViewStack.equationViewI.numI = equationViewNumbers.numI
            self.equationViewStack.equationViewII.numI = equationViewNumbers.numI
            self.equationViewStack.equationViewI.numII = equationViewNumbers.numII_I
            
            if let numII_II = equationViewNumbers.numII_II{
                self.equationViewStack.equationViewII.numII = numII_II
            }
        }
        
        let width : CGFloat = WIDTH//stackView.frame.width
        let buttonHeight : CGFloat
        var spaceCount = 0
        if(showButton){
            buttonHeight = BUTTON_HEIGHT
            spaceCount += 1
        }else{
            buttonHeight = 0.0
            self.nextButton.isHidden = true
        }
        
        let stackViewHeight : CGFloat
        if(equationViewNumbers != nil){
            if(equationViewNumbers!.numII_II != nil){
                stackViewHeight = (EQUATION_STACK_HEIGHT * 4)
            }else{
                stackViewHeight = EQUATION_STACK_HEIGHT
            }
            spaceCount += 1
        }else{
            stackViewHeight = 0.0
            self.equationViewStack.isHidden = true
            self.equationViewStack.equationViewI.isHidden = true
            self.equationViewStack.equationViewII.isHidden = true
        }
        stackViewHeightConstraint.constant = stackViewHeight
        stackView.layoutIfNeeded()
        
        let labelHeight = label.heightForLabel(width: width)
        
        let height : CGFloat = (labelHeight + buttonHeight + stackViewHeight + (2 * STACK_OFFSET) + (STACK_SPACING * CGFloat(spaceCount)))
        let x = (pointOfInterest.x - (width / 2))
        let y : CGFloat
        if(above){
            y = (pointOfInterest.y - height - Y_OFFSET)
        }else{
            y = pointOfInterest.y + Y_OFFSET
        }
        
        UIView.animate(withDuration: CHANGE_ANIMATION_DURATION, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.8, options: [.curveEaseInOut], animations: {
            
            self.frame = CGRect(x: x, y: y, width: width, height: height)
            self.setNeedsDisplay()
            self.setNeedsLayout()
            
            if(showButton){
                self.nextButton.isHidden = false
            }
            if let equationViewNumbers = equationViewNumbers{
                self.equationViewStack.isHidden = false
                if (equationViewNumbers.numII_II != nil){
                    self.equationViewStack.showView(state: .wrongBoth)
                }else{
                    self.equationViewStack.showView(state: .wrongFizz)
                }
            }
        }) {(completed) in}
    }
    
    func animateIn(){
        UIView.animate(withDuration: CHANGE_ANIMATION_DURATION, delay: 0.0, options: [.curveEaseInOut], animations: { [unowned self] in
            self.alpha = 1.0
        }, completion: nil)
    }
}

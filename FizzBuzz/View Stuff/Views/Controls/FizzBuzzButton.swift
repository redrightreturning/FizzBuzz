//
//  FizzBuzzButton.swift
//  FizzBuzz
//
//  Created by Elliot Goldman on 10/3/18.
//  Copyright © 2018 Elliot Keeler. All rights reserved.
//

import Foundation
import UIKit

class FizzBuzzButton : ButtonView{
    
    var label : UILabel?
    let fizzView = FizzView()
    let buzzView = BuzzView()
    var number : Int = 3 {
        didSet{
            label?.text = String(number)
        }
    }
    
    var isFizz = true{
        didSet{
            if(isFizz){
                fizzView.isHidden = false
                buzzView.isHidden = true
            }else{//!isFizz
                fizzView.isHidden = true
                buzzView.isHidden = false
            }
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
    
    func animateFizzOrBuzz(){
        if(fizzView.isHidden){
            buzzView.animateView()
        }else{//buzzView.isHidden
            fizzView.animateView()
        }
    }
    
    func setupView(){
        
        setupButton()
        
        //Add Number
        label = UILabel()
        label!.text = String(number)
        label!.textAlignment = .center
        label!.font = UIFont(name: "Futura", size: 50.0)
        label!.textColor = UIColor.white
        label!.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label!)
        let topLabelConstraint = NSLayoutConstraint(item: label!, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 12.0)
        let sizeLabelConstraint = NSLayoutConstraint(item: label!, attribute: .width, relatedBy: .equal, toItem: label!, attribute: .height, multiplier: 1.0, constant: 0.0)
        let leftLabelConstraint = NSLayoutConstraint(item: label!, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 20.0)
        let centerLabelConstraint = NSLayoutConstraint(item: label!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        self.addConstraints([topLabelConstraint, sizeLabelConstraint, leftLabelConstraint, centerLabelConstraint])
        
        //Add blob
        let blob = BlobView()
        self.addSubview(blob)
        blob.color = color
        blob.translatesAutoresizingMaskIntoConstraints = false
        let centerBlobConstraint = NSLayoutConstraint(item: blob, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let topBlobConstraint = NSLayoutConstraint(item: blob, attribute: .top, relatedBy: .equal, toItem: label, attribute: .bottom, multiplier: 1.0, constant: 8.0)
        let widthBlobConstraint = NSLayoutConstraint(item: blob, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 10.0)
        let sizeBlobConstraint = NSLayoutConstraint(item: blob, attribute: .width, relatedBy: .equal, toItem: blob, attribute: .height, multiplier: 1.0, constant: 0.0)
        self.addConstraints([centerBlobConstraint, topBlobConstraint, widthBlobConstraint, sizeBlobConstraint])
        
        //Add fizz or buzz
        self.addSubview(fizzView)
        fizzView.translatesAutoresizingMaskIntoConstraints = false
        fizzView.color = .white
        let leftFizzConstraint = NSLayoutConstraint(item: fizzView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 20.0)
        let rightFizzConstraint = NSLayoutConstraint(item: fizzView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: -18.0)
        let bottomFizzConstraint = NSLayoutConstraint(item: fizzView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -20.0)
        let topFizzConstraint = NSLayoutConstraint(item: fizzView, attribute: .top, relatedBy: .equal, toItem: blob, attribute: .top, multiplier: 1.0, constant: 40.0)
        self.addConstraints([leftFizzConstraint, rightFizzConstraint, bottomFizzConstraint, topFizzConstraint])
        
        self.addSubview(buzzView)
        buzzView.translatesAutoresizingMaskIntoConstraints = false
        buzzView.color = .white
        let leftBuzzConstraint = NSLayoutConstraint(item: buzzView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 20.0)
        let rightBuzzConstraint = NSLayoutConstraint(item: buzzView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: -18.0)
        let bottomBuzzConstraint = NSLayoutConstraint(item: buzzView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -20.0)
        let topBuzzConstraint = NSLayoutConstraint(item: buzzView, attribute: .top, relatedBy: .equal, toItem: blob, attribute: .top, multiplier: 1.0, constant: 40.0)
        self.addConstraints([leftBuzzConstraint, rightBuzzConstraint, bottomBuzzConstraint, topBuzzConstraint])
        
    }
}

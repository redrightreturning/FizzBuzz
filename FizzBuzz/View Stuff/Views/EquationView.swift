//
//  EquationView.swift
//  FizzBuzz
//
//  Created by Elliot Goldman on 10/8/18.
//  Copyright © 2018 Elliot Keeler. All rights reserved.
//

import Foundation
import UIKit

class EquationView : UIView, FizzBuzz{
    
    @IBInspectable var color : UIColor = UIColor.white{
        didSet{
            [numILabel, numIILabel, answerLabel].forEach{
                $0.textColor = color
            }
        }
    }
    
    var numI = 0{
        didSet{
            numILabel.text = String(numI)
            updateAnswer()
        }
    }
    var numII = 0{
        didSet{
            numIILabel.text = String(numII)
            updateAnswer()
        }
    }
    
    let stackView = UIStackView()
    private let numILabel = UILabel()
    let divisionView = DivisionView()
    private let numIILabel = UILabel()
    let equalView = EqualView()
    let answerLabel = UILabel()
        
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupView()
    }
    
    func setupView(){
        //StackView
        stackView.axis = .horizontal
        stackView.addArrangedSubview(numILabel)
        stackView.addArrangedSubview(divisionView)
        stackView.addArrangedSubview(numIILabel)
        stackView.addArrangedSubview(equalView)
        stackView.addArrangedSubview(answerLabel)
        
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        
        addSubviewAndPinToSides(view: stackView)
        
        //Labels
        [numILabel, numIILabel, answerLabel].forEach{
            $0.textAlignment = .center
            $0.font = UIFont(name: "Futura", size: 38.0)
            $0.adjustsFontSizeToFitWidth = true
            $0.baselineAdjustment = .alignCenters
            $0.textColor = color
            //$0.isHidden = true
        }
        
        //Others
        divisionView.color = tertiaryColor
        equalView.color = tertiaryColor
    }
    
    func updateAnswer(){
        if(numII != 0){
            let num = numI / numII
            let remainder = numI % numII
            if(remainder == 0){
                answerLabel.text = "\(num)"
            }else{
                answerLabel.text = "\(num)r\(remainder)"
            }
        }else{
            answerLabel.text = String(0)
        }
    }
}

//
//  EquationViewStack.swift
//  FizzBuzz
//
//  Created by Elliot Goldman on 10/8/18.
//  Copyright © 2018 Elliot Keeler. All rights reserved.
//

import Foundation
import UIKit

class EquationViewStack : UIView{
    
    let stackView = UIStackView()
    let equationViewI = EquationView()
    let equationViewII = EquationView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupView()
    }
    
    func animateView(state : FizzBuzzGameState){
        animateView(state: state, animateIn: true)
    }
    
    func animateViewOut(){
        animateView(state: .wrongBoth, animateIn: false)
    }
    
    func animateView(state : FizzBuzzGameState, animateIn : Bool){
        
        guard (state != .fizz) && (state != .buzz) && (state != .number) && (state != .fizzBuzz) else {
            print("EquationViewStack is being asked to animate with a view it doesn't support. You screwed up.")
            return
        }
        if(animateIn){
            isHidden = false
        }
        equationViewI.isHidden = animateIn
        equationViewII.isHidden = animateIn
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 2, options: [], animations: { [unowned self] in
            if(state == .wrongFizz || state == .wrongBoth){
                self.equationViewI.isHidden = !animateIn
            }
            if(state == .wrongBuzz || state == .wrongBoth){
                self.equationViewII.isHidden = !animateIn
            }
        }){[unowned self] (completed) in
            if(!animateIn){
                self.isHidden = true
            }
        }
    }
    
    func showView(state : FizzBuzzGameState){
        guard (state != .fizz) && (state != .buzz) && (state != .number) && (state != .fizzBuzz) else {
            print("EquationViewStack is being asked to animate with a view it doesn't support. You screwed up.")
            return
        }
        equationViewI.isHidden = true
        equationViewII.isHidden = true
        if(state == .wrongFizz || state == .wrongBoth){
            self.equationViewI.isHidden = false
        }
        if(state == .wrongBuzz || state == .wrongBoth){
            self.equationViewII.isHidden = false
        }
        self.isHidden = false
    }
    
    
    
    func setupView(){
        stackView.axis = .vertical
        stackView.addArrangedSubview(equationViewI)
        stackView.addArrangedSubview(equationViewII)
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        
        addSubviewAndPinToSides(view: stackView)
    }
}

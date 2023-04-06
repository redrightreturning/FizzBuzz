//
//  PauseViewController.swift
//  FizzBuzz
//
//  Created by Elliot Goldman on 10/16/18.
//  Copyright © 2018 Elliot Keeler. All rights reserved.
//

import UIKit

protocol PauseDelegate {
    func unpause()
}

class PauseViewController: UIViewController, FizzBuzz{

    let ANIMATION_DURATION : TimeInterval = 0.5
    let BACKGROUND_COLOR = UIColor(white: 0.0, alpha: 0.2)
    let DELAY : TimeInterval = 1.0
    let FONT_SIZE = 75.0
    static let STORYBOARD_ID = "PauseViewController"
    
    var delegate : PauseDelegate?
    @IBOutlet weak var numberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = BACKGROUND_COLOR
        numberLabel.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: ANIMATION_DURATION, delay: 0.0, options: [.curveEaseInOut], animations: {[unowned self] in
            self.numberLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }){[unowned self] (completed) in
            self.audioManager.playOther()
        }
        
        //2
        DispatchQueue.main.asyncAfter(deadline: .now() + DELAY) {[unowned self] in
            self.numberLabel.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
            self.numberLabel.text = "2"
            
            UIView.animate(withDuration: self.ANIMATION_DURATION, delay: 0.0, options: [.curveEaseInOut], animations: {[unowned self] in
                self.numberLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }){[unowned self] (completed) in
                self.audioManager.playOther()
            }
            
            //1
            DispatchQueue.main.asyncAfter(deadline: .now() + self.DELAY) {[unowned self] in
                self.numberLabel.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
                self.numberLabel.text = "1"
                
                UIView.animate(withDuration: self.ANIMATION_DURATION, delay: 0.0, options: [.curveEaseInOut], animations: {[unowned self] in
                    self.numberLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }){[unowned self] (completed) in
                    self.audioManager.playOther()
                }
                
                //Dismiss
                DispatchQueue.main.asyncAfter(deadline: .now() + self.DELAY) {[unowned self] in
                    
                    self.dismiss(animated: false){
                        self.audioManager.openMenu()
                        self.delegate?.unpause()
                    }
                }
            }
        }
    }

}

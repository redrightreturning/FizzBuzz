//
//  MenuViewController.swift
//  FizzBuzz
//
//  Created by Elliot Goldman on 9/10/18.
//  Copyright © 2018 Elliot Keeler. All rights reserved.
//

import Foundation
import UIKit

class MenuViewController: UIViewController, FizzBuzz, UserSettings, DeviceFeedback{
    
    let HIGH_SCORE_ANIMATE_OUT_SPEED = 0.06
    let HIGH_SCORE_ANIMATE_OUT_AMOUNT = 6
    
    
    @IBOutlet weak var blobView: BlobView!
    @IBOutlet weak var crownView: CrownView!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var infoView: InfoView!
    
    @IBOutlet weak var speakerView: SpeakerView!
    @IBOutlet weak var startButtonNumberI: UILabel!
    @IBOutlet weak var startButtonNumberII: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    var set : FizzBuzzNumberSet = .tf{
        didSet{
            startButtonNumberI.text = String(set.numbers().numI)
            startButtonNumberII.text = String(set.numbers().numII)
            resetHighScoreLabel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = mainColor
        startButton.tintColor = tertiaryColor
        crownView.color = tertiaryColor
        crownView.isOpaque = false
        
        //Set defaults
        resetHighScoreLabel()
        set = savedSet()
        speakerView.on = !isMuted()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        resetHighScoreLabel()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func resetHighScoreLabel(){
        highScoreLabel.text = String(highScore(set: set))
    }
    
    func animateHighScoreOut(completion : (()->())?){
        let _ = Timer.scheduledTimer(withTimeInterval:HIGH_SCORE_ANIMATE_OUT_SPEED , repeats: true){[unowned self] timer in
            var num : Int
            if let text = self.highScoreLabel.text{
                num = Int(text)!
            }else{
                num = 1
            }
            if(num > 1 && (num > (self.highScore(set: self.set) - self.HIGH_SCORE_ANIMATE_OUT_AMOUNT))){
                num -= 1
                self.highScoreLabel.text = String(num)
            }else{
                timer.invalidate()
                completion?()
            }
        }
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        mediumDeviceFeedback()
        
        //TODO: Animate into high score
        
        if(notFirstOpen()){
            animateHighScoreOut(){[unowned self] in
                let storyBoard = UIStoryboard(name: self.storyboardName, bundle: nil)
                let gameViewController = storyBoard.instantiateViewController(withIdentifier: GameViewController.STORYBOARD_ID) as! GameViewController
                gameViewController.set = self.set
                self.present(gameViewController, animated: false){[unowned self] in
                    //Put the high score back
                    self.resetHighScoreLabel()
                    self.audioManager.startGame()
                }
            }
        }else{
            let storyBoard = UIStoryboard(name: self.storyboardName, bundle: nil)
            let howToViewController = storyBoard.instantiateViewController(withIdentifier: HowToViewController.STORYBOARD_ID) as! HowToViewController
            howToViewController.isFirstPresentation = true
            present(howToViewController, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func numberViewTapped(_ sender: PoundSignView) {
        mediumDeviceFeedback()
        sender.animateView()
        
        if(set == .tf){
            set = .fs
        }else if(set == .fs){
            set = .ts
        }else if(set == .ts){
            set = .te
        }else if(set == .te){
            set = .fis
        }else if(set == .fis){
            set = .tf
        }
        saveSet(set: set)
        //Redisplay blob view to get a new blob
        blobView.changeBlob()
        audioManager.changeSet()
    }
    
    @IBAction func speakerViewTapped(_ sender: SpeakerView) {
        mediumDeviceFeedback()
        sender.on = !sender.on
        setMuted(muted: !sender.on)
        audioManager.soundOn()
    }
    
    @IBAction func infoViewTapped(_ sender: InfoView) {
        mediumDeviceFeedback()
        sender.animateView()
        audioManager.openMenu()
        let storyBoard = UIStoryboard(name: self.storyboardName, bundle: nil)
        let aboutViewController = storyBoard.instantiateViewController(withIdentifier: AboutViewController.STORYBOARD_ID) as! AboutViewController
        aboutViewController.modalPresentationStyle = .overCurrentContext
        aboutViewController.delegate = self
        self.present(aboutViewController, animated: true){}
    }
}

extension MenuViewController : AboutViewControllerDelegate{
    func dismissed() {
        infoView.stopAnimating()
    }
}

//
//  ViewController.swift
//  FizzBuzz
//
//  Created by Elliot Goldman on 9/10/18.
//  Copyright © 2018 Elliot Keeler. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, FizzBuzz, DeviceFeedback{

    static let STORYBOARD_ID = "GameViewController"
    let BLOB_FADE_DURATION : TimeInterval = 1.0
    let GRADIENT_FADE_DURATION : TimeInterval = 0.6
    
    @IBOutlet weak var blobViewI: BlobView!
    @IBOutlet weak var blobViewII: BlobView!
    @IBOutlet weak var crownView: CrownView!
    @IBOutlet weak var equationStackView: EquationViewStack!
    @IBOutlet weak var fizzBuzzButtonsView: FizzBuzzButtonsView!
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var touchView: UIView!
    
    lazy var fizzBuzzGame : FizzBuzzGame = {
        if let set = set{
            return FizzBuzzGame(set : set)
        }else{
            print("You didn't set numbers before the game loaded!")
            return FizzBuzzGame(set : .tf)
        }
    }()
    var isGameOver = false
    var set : FizzBuzzNumberSet?{
        didSet{
            fizzBuzzGame = FizzBuzzGame(set: set!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fizzBuzzGame.delegate = self
        fizzBuzzButtonsView.delegate = self
        fizzBuzzButtonsView.number1 = set!.numbers().numI
        fizzBuzzButtonsView.number2 = set!.numbers().numII
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped(sender: )))
        touchView.addGestureRecognizer(tap)
        
        setNumberLabel()
        
        crownView.color = tertiaryColor
        crownView.alpha = 0.0
        
        equationStackView.isHidden = true
        equationStackView.equationViewI.numII = set!.numbers().numI
        equationStackView.equationViewII.numII = set!.numbers().numII
        
        //Subscribe to App Delegate notifications to know when to pause the game
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setNumberLabel(){
        numberLabel.text = String(fizzBuzzGame.number)
        //Check if it's a divisible of 10 and if so increase the sound
        if(fizzBuzzGame.number % 10 == 0){
            audioManager.incrementOffset()
        }
    }
    
    @objc func viewTapped(sender : UITapGestureRecognizer){
        if(!isGameOver){
            let result = fizzBuzzGame.increaseNumber()
            setNumberLabel()
            audioManager.playNumber()
            if(result == FizzBuzzGameState.number){
                print("number")
                lightDeviceFeedback()
            }else{
                gameOver(state: result)
            }
        }
    }
    
    func fadeGradientOut(){
        let timerInterval = 0.1
        let timeSteps = (GRADIENT_FADE_DURATION * (1 - gradientView.percent)) / timerInterval
        let increment = (1 - gradientView.percent) / timeSteps
        let timer = Timer(fire: Date(), interval: timerInterval, repeats: true) { [unowned self] (timer) in
            self.gradientView.percent = (self.gradientView.percent + increment)
            if(self.gradientView.percent >= 1.0){
                timer.invalidate()
            }
        }
        RunLoop.main.add(timer, forMode: .default)
    }

    func fadeBlobsIn(completion : @escaping ()->()){
        UIView.animate(withDuration: BLOB_FADE_DURATION, delay: 0.0, options: [.curveEaseInOut], animations: { [unowned self] in
            self.blobViewI.alpha = 1.0
            self.blobViewII.alpha = 1.0
            
            //Fade in crown too if it's a high score
            if(self.fizzBuzzGame.isHighScore){
                self.crownView.alpha = 1.0
            }
            
        }) { (complete) in
            completion()
        }
    }

    func fadeBlobsOut(completion : @escaping ()->()){
        UIView.animate(withDuration: BLOB_FADE_DURATION, delay: 0.0, options: [.curveEaseInOut], animations: { [unowned self] in
            self.blobViewI.alpha = 0.0
            self.blobViewII.alpha = 0.0
        }) { (complete) in
            completion()
        }
    }
    
    func gameOver(state: FizzBuzzGameState){
        print("Game Over!")
        isGameOver = true
        fizzBuzzButtonsView.activated = false
        heavyDeviceFeedback()
        audioManager.gameOver()
        fadeGradientOut()
        
        //Show solution
        equationStackView.equationViewI.numI = fizzBuzzGame.number
        equationStackView.equationViewII.numI = fizzBuzzGame.number
        equationStackView.animateView(state: state)
        
        fadeBlobsIn {[unowned self] in
            self.fadeBlobsOut {[unowned self] in
                self.fadeBlobsIn {[unowned self] in
                    self.fadeBlobsOut {[unowned self] in
                        self.fadeBlobsIn {[unowned self] in
                            self.fadeBlobsOut {[unowned self] in
                                self.dismiss(animated: false){}
                            }
                        }
                    }
                }
            }
        }
        
    }
}

extension GameViewController : FizzBuzzGameDelegate {
    func timeUp(state : FizzBuzzGameState) {
        print("Times Up!!!")
        gameOver(state: state)
    }
    
    func timeLeft(percent: Double) {
        gradientView.percent = percent
    }
}

extension GameViewController : FizzBuzzButtonsViewDelegate{
    func buttonTapped(button : FizzBuzzButtonsViewButtons){
        let result : FizzBuzzGameState
        if(button == FizzBuzzButtonsViewButtons.fizz){
            print("fizz")
            result = fizzBuzzGame.increaseByFizz()
            audioManager.playFizz()
        }else if(button == FizzBuzzButtonsViewButtons.buzz){
            print("buzz")
            result = fizzBuzzGame.increaseByBuzz()
            audioManager.playBuzz()
        }else{ //button == FizzBuzzButtonsViewButtons.fizzBuzz
            print("fizzBuzz")
            result = fizzBuzzGame.increaseByFizzBuzz()
            audioManager.playFizzBuzz()
        }
        if(result == FizzBuzzGameState.wrongFizz || result == FizzBuzzGameState.wrongBuzz || result == FizzBuzzGameState.wrongBoth){
            gameOver(state: result)
        }else{
            setNumberLabel()
            mediumDeviceFeedback()
        }
    }
}

extension GameViewController : PauseDelegate{
    func unpause() {
        fizzBuzzGame.unPause()
    }
    
    //Not delegate but related to pause and unpause
    
    @objc func applicationWillResignActive(){
        pause()
    }
    
    @objc func applicationDidBecomeActive(){
        launchPauseScreen()
    }
    
    func pause(){
        fizzBuzzGame.pause()
    }
    
    func launchPauseScreen(){
        let storyBoard = UIStoryboard(name: self.storyboardName, bundle: nil)
        let pauseViewController = storyBoard.instantiateViewController(withIdentifier: PauseViewController.STORYBOARD_ID) as! PauseViewController
        pauseViewController.modalPresentationStyle = .overCurrentContext
        pauseViewController.delegate = self
        self.present(pauseViewController, animated: false){}
    }
}

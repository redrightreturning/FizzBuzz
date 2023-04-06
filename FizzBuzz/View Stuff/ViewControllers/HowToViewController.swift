//
//  HowToViewController.swift
//  FizzBuzz
//
//  Created by Elliot Goldman on 10/6/18.
//  Copyright © 2018 Elliot Keeler. All rights reserved.
//

import UIKit

class HowToViewController: UIViewController, FizzBuzz, DeviceFeedback, UserSettings{
    
    let BLOB_FADE_DURATION : TimeInterval = 1.0
    static let EQUATION_SIDE_OFFSET : CGFloat = 2.0
    static let EQUATION_LINE_WIDTH : CGFloat = 3.0
    static let STORYBOARD_ID = "HowToViewController"
    let TIMER_TIME = 8.0
    let UPDATE_TIMER_INTERVAL = 0.1
    
    @IBOutlet weak var blobViewI: BlobView!
    @IBOutlet weak var blobViewII: BlobView!
    @IBOutlet weak var cancelButton: CancelView!
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var equationViewStack: EquationViewStack!
    @IBOutlet weak var touchView: UIView!
    @IBOutlet weak var fizzBuzzButtonsView: FizzBuzzButtonsView!
    
    var actions = [(function : ()->(), expectedState : FizzBuzzGameState, wrongFunction : (()->())?)]()
    var isFirstPresentation = true
    var lastTime = Date()
    let popoverView = PopoverView()
    let set : FizzBuzzNumberSet = .tf
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fizzBuzzButtonsView.delegate = self
        fizzBuzzButtonsView.number1 = set.numbers().numI
        fizzBuzzButtonsView.number2 = set.numbers().numII
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped(sender: )))
        touchView.addGestureRecognizer(tap)
        
        equationViewStack.isHidden = true
        equationViewStack.equationViewI.numII = set.numbers().numI
        equationViewStack.equationViewII.numII = set.numbers().numII
        
        if(isFirstPresentation == true){
            cancelButton.isHidden = true
        }
        //temporary setting the frame since it's hidden anyways
        popoverView.frame = view.frame
        popoverView.delegate = self
        self.view.addSubview(popoverView)
        
        let centerPoint = CGPoint(x: view.frame.midX, y: view.frame.midY)
        let bottomPoint = CGPoint(x: view.frame.midX, y: view.frame.maxY - 40.0)
        let threePoint = CGPoint(x: (self.fizzBuzzButtonsView.frame.midX - (self.fizzBuzzButtonsView.frame.width / 4)), y: self.fizzBuzzButtonsView.frame.minY)
        let fivePoint = CGPoint(x: (self.fizzBuzzButtonsView.frame.midX + (self.fizzBuzzButtonsView.frame.width / 4)), y: self.fizzBuzzButtonsView.frame.minY)
        //Welcome
        let welcomeAction = {[unowned self] in
            self.popoverView.animateIn()
            self.audioManager.openMenu()
            self.popoverView.configurePopoverView(pointOfInterest: centerPoint, above: true, text: "Welcome to Fizzbuzz!", showButton: true, equationViewNumbers: nil)
            self.popoverView.animateIn()
        }
        actions.append((function : welcomeAction, expectedState : .wrongBoth, wrongFunction : {}))
        
        //What is fizzbuzz
        let whatAction = {[unowned self] in
            self.audioManager.openMenu()
            self.popoverView.configurePopoverView(pointOfInterest: centerPoint, above: true, text: "Fizzbuzz is a game of division.", showButton: true, equationViewNumbers: (numI : 9, numII_I : 3, numII_II : nil))
        }
        actions.append((function : whatAction, expectedState : .wrongBoth, wrongFunction : nil))
        
        //1
        let numberPoint = CGPoint(x: view.frame.midX, y: touchView.frame.maxX)
        let oneAction = {[unowned self] in
            self.audioManager.openMenu()
            self.popoverView.configurePopoverView(pointOfInterest: numberPoint, above: false, text: "1 isn’t divisible by 3 or 5 so tap the number to move forward.", showButton: false, equationViewNumbers: nil)
        }
        actions.append((function : oneAction, expectedState : .number, wrongFunction :nil))
        
        //2
        let twoAction = {[unowned self] in
            self.numberLabel.text = "2"
            self.popoverView.configurePopoverView(pointOfInterest: numberPoint, above: false, text: "2 isn’t either, so tap the number again.", showButton: false, equationViewNumbers: nil)
        }
        actions.append((function : twoAction, expectedState : .number, wrongFunction : nil))
        
        //3
        let threeAction = {[unowned self] in
            self.numberLabel.text = "3"
            self.popoverView.configurePopoverView(pointOfInterest: threePoint, above: true, text: "3 is divisible by 3 (Fizz), so tap it! ", showButton: false, equationViewNumbers: nil)
        }
        actions.append((function : threeAction, expectedState : .fizz, wrongFunction : {
            self.popoverView.configurePopoverView(pointOfInterest: threePoint, above: true, text: "Try again!", showButton: false, equationViewNumbers: (numI : 3, numII_I : 3, numII_II : nil))
        }))
        
        //4
        let fourAction = {[unowned self] in
            self.numberLabel.text = "4"
            self.popoverView.configurePopoverView(pointOfInterest: numberPoint, above: true, text: "What about 4?", showButton: false, equationViewNumbers: nil)
        }
        actions.append((function : fourAction, expectedState : .number, wrongFunction : {
            self.popoverView.configurePopoverView(pointOfInterest: bottomPoint, above: true, text: "Nope! 4 isn’t divisible by 3 or 5", showButton: false, equationViewNumbers: (numI : 4, numII_I : 3, numII_II : 5))
        }))
        
        //5
        let fiveAction = {[unowned self] in
            self.numberLabel.text = "5"
            
            self.popoverView.configurePopoverView(pointOfInterest: fivePoint, above: true, text: "5 is divisible by 5 (Buzz), so tap it! ", showButton: false, equationViewNumbers: nil)
        }
        actions.append((function : fiveAction, expectedState : .buzz, wrongFunction : {
            self.popoverView.configurePopoverView(pointOfInterest: fivePoint, above: true, text: "Try again!", showButton: false, equationViewNumbers: (numI : 5, numII_I : 5, numII_II : nil))
        }))
        
        //6
        let sixAction = {[unowned self] in
            self.numberLabel.text = "6"
            self.popoverView.configurePopoverView(pointOfInterest: numberPoint, above: true, text: "How about 6?", showButton: false, equationViewNumbers: nil)
        }
        actions.append((function : sixAction, expectedState : .fizz, wrongFunction : {
            self.popoverView.configurePopoverView(pointOfInterest: numberPoint, above: true, text: "Nope! 6 is divisible by 3. Try that!", showButton: false, equationViewNumbers: (numI : 6, numII_I : 3, numII_II : nil))
        }))
        
        //Good Job
        //6
        let goodJobAction = {[unowned self] in
            self.popoverView.configurePopoverView(pointOfInterest: numberPoint, above: true, text: "Good Job!", showButton: true, equationViewNumbers: nil)
        }
        actions.append((function : goodJobAction, expectedState : .wrongBoth, wrongFunction : nil))
        
        //FizzBuzz
        let fizzBuzzAction = {[unowned self] in
            self.audioManager.openMenu()
            self.numberLabel.text = "15"
            self.popoverView.configurePopoverView(pointOfInterest: centerPoint, above: true, text: "If the number is divisible by both 3 and 5 (Fizzbuzz), hit both buttons at the same time.", showButton: false, equationViewNumbers: nil)
            
        }
        actions.append((function : fizzBuzzAction, expectedState : .fizzBuzz, wrongFunction : {
            self.popoverView.configurePopoverView(pointOfInterest: numberPoint, above: true, text: "Try hitting both buttons at the same time", showButton: false, equationViewNumbers: (numI : 15, numII_I : 3, numII_II : 5))
        }))
        
        //Time
        let timeAction = {[unowned self] in
            self.numberLabel.text = "16"
            self.popoverView.configurePopoverView(pointOfInterest: centerPoint, above: true, text: "There’s also a timer. You can tell how much time you have by the color of the background.", showButton: true, equationViewNumbers: nil)
            
            self.gradientView.percent = 1.0
            let timer = Timer(timeInterval: self.UPDATE_TIMER_INTERVAL, target: self, selector: #selector(self.timerTriggered(sender:)), userInfo: nil, repeats: true)
            self.lastTime = Date()
            RunLoop.main.add(timer, forMode: RunLoop.Mode.default)
        }
        actions.append((function : timeAction, expectedState : .wrongBoth, wrongFunction : nil))
        
        //Times Up
        let timesUpAction = {[unowned self] in
            self.popoverView.configurePopoverView(pointOfInterest: bottomPoint, above: true, text: "When the timer runs out, the game is over.", showButton: true, equationViewNumbers: nil)
            
            self.gameOver()
        }
        actions.append((function : timesUpAction, expectedState : .wrongBoth, wrongFunction : nil))
        
        //Different Numbers
        let differentNumbersAction = {[unowned self] in
            self.numberLabel.text = "1"
            self.audioManager.openMenu()
            self.popoverView.configurePopoverView(pointOfInterest: centerPoint, above: true, text: "When you master 3 and 5, you can try with different numbers.", showButton: true, equationViewNumbers: nil)
            self.equationViewStack.isHidden = true
            self.blobViewI.isHidden = true
            self.blobViewII.isHidden = true
            self.fizzBuzzButtonsView.number1 = 4
            self.fizzBuzzButtonsView.number2 = 6
            
        }
        actions.append((function : differentNumbersAction, expectedState : .wrongBoth, wrongFunction : nil))
        
        //Good Luck
        let goodLuckAction = {[unowned self] in
            self.audioManager.openMenu()
            self.popoverView.configurePopoverView(pointOfInterest: centerPoint, above: true, text: "Good luck and have fun!", showButton: true, equationViewNumbers: nil)
        }
        actions.append((function : goodLuckAction, expectedState : .wrongBoth, wrongFunction : nil))
        
        //Finished tutorial
        actions.append((function : dismissView, expectedState : .wrongBoth, wrongFunction : nil))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        howTo()
    }
    
    func howTo(){
        actions[0].function()
    }
    
    func nextHowTo(){
        guard actions.count > 0 else{
            fatalError("You don't have any actions left! What'd you do here?")
        }
        actions.remove(at: 0)
        howTo()
    }
    
    @objc func viewTapped(sender : UITapGestureRecognizer){
        if(actions[0].expectedState == .number){
            lightDeviceFeedback()
            audioManager.playNumber()
            nextHowTo()
        }else{
           userIsWrong()
        }
    }
    
    func userIsWrong(){
        heavyDeviceFeedback()
        audioManager.gameOver()
        actions[0].wrongFunction?()
    }
    
    func dismissView(){
        lightDeviceFeedback()
        self.audioManager.closeMenu()
        cancelButton.animateView()
        setNotFirstOpen(notFirstOpen: true)
        dismiss(animated: true){}
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismissView()
    }
    
    @objc func timerTriggered(sender : Timer){
        if((-1 * lastTime.timeIntervalSinceNow) >= TIMER_TIME){
            sender.invalidate()
        }else{
            let percent = (-1 * lastTime.timeIntervalSinceNow) / TIMER_TIME
            gradientView.percent = percent
        }
        
    }
    
    func fadeBlobsIn(completion : @escaping ()->()){
        UIView.animate(withDuration: BLOB_FADE_DURATION, delay: 0.0, options: [.curveEaseInOut], animations: { [unowned self] in
            self.blobViewI.alpha = 1.0
            self.blobViewII.alpha = 1.0
            
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
    
    func gameOver(){
        fizzBuzzButtonsView.activated = false
        heavyDeviceFeedback()
        audioManager.gameOver()
        
        //Show solution
        equationViewStack.equationViewI.numI = 16
        equationViewStack.equationViewII.numI = 16
        equationViewStack.equationViewI.numII = 3
        equationViewStack.equationViewII.numII = 5
        equationViewStack.animateView(state: .wrongBoth)
        
        fadeBlobsIn {[unowned self] in
            self.fadeBlobsOut {[unowned self] in
                self.fadeBlobsIn {[unowned self] in
                    self.fadeBlobsOut {[unowned self] in
                        self.fadeBlobsIn {[unowned self] in
                            self.fadeBlobsOut {}
                        }
                    }
                }
            }
        }
        
    }
}

extension HowToViewController : FizzBuzzButtonsViewDelegate{
    func buttonTapped(button : FizzBuzzButtonsViewButtons){
        if((actions[0].expectedState == .fizz && button == .fizz) || (actions[0].expectedState == .buzz && button == .buzz) || (actions[0].expectedState == .fizzBuzz && button == .fizzBuzz)){
            lightDeviceFeedback()
            if(button == .fizz){
                audioManager.playFizz()
            }else if(button == .buzz){
                audioManager.playBuzz()
            }else{//.fizzbuzz
                audioManager.playFizzBuzz()
            }
            nextHowTo()
        }else{
            userIsWrong()
        }
    }
}

extension HowToViewController : PopoverViewDelegate{
    func buttonPressed() {
        lightDeviceFeedback()
        nextHowTo()
    }
    
    
}

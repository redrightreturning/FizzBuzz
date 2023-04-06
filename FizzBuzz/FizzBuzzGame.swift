//
//  FizzBuzzGame.swift
//  FizzBuzz
//
//  Created by Elliot Goldman on 9/10/18.
//  Copyright © 2018 Elliot Keeler. All rights reserved.
//

import Foundation

enum FizzBuzzNumberSet : Int{
    case tf = 0
    case fs
    case ts
    case te
    case fis
    
    func numbers()->(numI : Int, numII : Int){
        if(self == .tf){
            return (3, 5)
        }else if(self == .fs){
            return (4, 6)
        }else if(self == .ts){
            return (3, 7)
        }else if(self == .te){
            return (3, 8)
        }else{ //self == .fis
            return (5, 7)
        }
    }
    
    func toString()->String{
        if(self == .tf){
            return "tf"
        }else if(self == .fs){
            return "fs"
        }else if(self == .ts){
            return "ts"
        }else if(self == .te){
            return "te"
        }else{ //self == .fis
            return "fis"
        }
    }
    
    static func toSet(string : String)->FizzBuzzNumberSet{
        if(string == "tf"){
            return .tf
        }else if(string == "fs"){
            return .fs
        }else if(string == "ts"){
            return .ts
        }else if(string == "te"){
            return .te
        }else{ //string == "fis"
            return .fis
        }
    }
}

enum FizzBuzzGameState{
    case fizz
    case buzz
    case fizzBuzz
    case number
    case wrongFizz //Fizz but not fizz OR should have been fizz
    case wrongBuzz
    case wrongBoth
}

enum FizzBuzzGameMode{
    case hideNext
    case regular
    case random
    case learn
}

protocol FizzBuzzGameDelegate{
    func timeLeft(percent : Double)
    func timeUp(state : FizzBuzzGameState)
}

class FizzBuzzGame : NSObject, FizzBuzz, UserSettings{
    
    let UPDATE_TIMER_INTERVAL = 0.1
    
    let set : FizzBuzzNumberSet
    var delegate : FizzBuzzGameDelegate?
    var lastTime = Date()
    var mode : FizzBuzzGameMode = .regular
    var number : Int = 1
    var paused : Bool = false
    var pauseTimeLeft = 0.0
    var isHighScore : Bool{
        return(number > oldHighScore!)
    }
    var oldHighScore : Int?
    lazy var time : Double = { //In seconds
        return Double(defaultStartTime)
    }()
    lazy var timer : Timer = {
        return Timer(timeInterval: UPDATE_TIMER_INTERVAL, target: self, selector: #selector(self.timerTriggered(sender:)), userInfo: nil, repeats: true)
    }()
    
    
    init(set : FizzBuzzNumberSet){
        self.set = set
        super.init()
        oldHighScore = highScore(set: set)
        RunLoop.main.add(timer, forMode: RunLoop.Mode.default)
    }
    
    @objc func timerTriggered(sender : Timer){
        if(!paused){
            if((-1 * lastTime.timeIntervalSinceNow + pauseTimeLeft) >= time){
                delegate?.timeUp(state: gameOver(state: .number))
            }else{
                let percent = (-1 * lastTime.timeIntervalSinceNow  + pauseTimeLeft) / time
                delegate?.timeLeft(percent: percent)
            }
        }
    }
    
    func pause(){
        paused = true
        pauseTimeLeft = (-1 * lastTime.timeIntervalSinceNow)
    }
    
    func unPause(){
        paused = false
        lastTime = Date()
    }
    
    func keepPlaying(){
        time -= 0.1
        lastTime = Date()
        pauseTimeLeft = 0.0
        if(mode == .regular){
            number += 1
        }else if(mode == .random){
            number = Int.random(in: 0...500)
        }
    }
    
    func gameOver(state : FizzBuzzGameState)->FizzBuzzGameState{
        timer.invalidate()
        //Subtract the number because the player didn't get the current answer correct
        
        if((number - 1) > highScore(set: set)){
            setHighScore(newHighScore: (number - 1), set: set)
        }
        
        //User hit button but it was wrong
        var fizzOn = false
        var buzzOn = false
        if((state == .fizz) || (state == .fizzBuzz)){
            fizzOn = true
        }
        if((state == .buzz) || (state == .fizzBuzz)){
            buzzOn = true
        }
        //User didn't hit button when they should have
        if(number % set.numbers().numI == 0){
            fizzOn = true
        }
        if(number % set.numbers().numII == 0){
            buzzOn = true
        }
        
        if(fizzOn && buzzOn){
            return .wrongBoth
        }else if(fizzOn){
            return .wrongFizz
        }else{ //buzzOn
            return .wrongBuzz
        }
    }
    
    func increaseNumber()->FizzBuzzGameState{
        //If playing hide next mode test for next number instead of current
        if(mode == .hideNext){
            number += 1
        }
        //If the number isn't divisible by either of the numbers
        if(!(number % set.numbers().numI == 0) && !(number % set.numbers().numII == 0)){
            keepPlaying()
            return .number
        }else{
            return gameOver(state: .number)
        }
    }
    
    func increaseByFizz()->FizzBuzzGameState{
        //If playing hide next mode test for next number instead of current
        if(mode == .hideNext){
            number += 1
        }
        //If number is divisibble by the first number but not the second
        if((number % set.numbers().numI == 0) && !(number % set.numbers().numII == 0)){
            keepPlaying()
            return .fizz
        }else{
            return gameOver(state : .fizz)
        }
    }
    
    func increaseByBuzz()->FizzBuzzGameState{
        //If playing hide next mode test for next number instead of current
        if(mode == .hideNext){
            number += 1
        }
        //If number is divisibble by the first number but not the second
        if(!(number % set.numbers().numI == 0) && (number % set.numbers().numII == 0)){
            keepPlaying()
            return .buzz
        }else{
            return gameOver(state : .buzz)
        }
    }
    
    func increaseByFizzBuzz()->FizzBuzzGameState{
        //If playing hide next mode test for next number instead of current
        if(mode == .hideNext){
            number += 1
        }
        //If number is divisibble by the first number but not the second
        if((number % set.numbers().numI == 0) && (number % set.numbers().numII == 0)){
            keepPlaying()
            return .fizzBuzz
        }else{
            return gameOver(state: .fizzBuzz)
        }
    }
}
